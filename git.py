#!/usr/bin/env python3

"""
Git Configuration Aid
@author edurso
"""

import os
import subprocess
import sys
from configparser import ConfigParser
from getpass import getpass
from pathlib import Path
from subprocess import CompletedProcess
from typing import TypeAlias

GitConfig: TypeAlias = dict[str, dict[str, str]]


def get(prompt: str, default_value: str = None) -> str:
    """
    Get a value from the user
    :param prompt: Prompt message
    :param default_value: Gets returned if user provides no input
    :return: The user's input
    """
    msg = f'{prompt}: ' if default_value is None else f'{prompt} [{default_value}]: '
    user_input = input(msg).strip()
    return user_input if user_input else default_value


def get_valid(prompt: str) -> str:
    """
    Persistently prompt user for input until given
    :param prompt: Prompt message
    :return: The user's input
    """
    user_input = None
    while user_input is None:
        user_input = get(prompt)
    return user_input


def run(command: list[str] | str, simple: bool = False, print_output: bool = False) -> CompletedProcess[str] | str:
    """
    Run a system command and return its output
    :param command: Command to run
    :param simple: True to return entire result object, False for just stdout
    :param print_output: Flag to print output of command to output buffer
    :return: Command output as defined by simple
    """
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if print_output:
        print(result)
    if simple:
        return result
    return result.stdout.strip()


def yes_no(prompt: str) -> bool:
    """
    Give the user a yes or no prompt (y/n)
    :param prompt: Prompt message (excluding y/n indications)
    :return: The user's input as a boolean
    """
    while True:
        response = input(f'{prompt} (y/n): ').strip().lower()
        if len(response) > 1:
            response = response[0]
        if response in ['y', 'n']:
            return response == 'y'


def check_git_installed() -> None:
    """
    Determine if git is installed on the system, halt with non-zero exit if it is missing
    :return: None
    """
    try:
        run(["git", "--version"])
    except subprocess.CalledProcessError:
        print('git is not installed, please install and rerun this script')
        sys.exit(1)


def get_basic_config() -> GitConfig:
    """
    Resolve basic user information
    :return: A basic gitconfig of the user's information as a dictionary
    """
    print('this interface will prompt you for your git details, and assist you in configuring your machine')

    name = None
    email = None
    correct = False
    while not correct:
        name = get_valid('name')
        email = get_valid('email')
        correct = yes_no('please confirm that the above details are correct')

    editor = get('preferred editor (e.g., vim, nano, code)', 'vim')
    diff_tool = get('diff tool (e.g., vimdiff, meld)', 'vimdiff')
    return {
        "user": {
            "name": name,
            "email": email,
        },
        "core": {
            "editor": editor,
        },
        "diff": {
            "tool": diff_tool,
        },
    }


def get_base_config(config: GitConfig) -> GitConfig:
    """
    Combine config with the base .gitconfig file if it exists
    :param config: Git configuration
    :return: Combined git configuration
    """
    gitconfig_path = Path(Path(__file__).parent, '.base_gitconfig')
    if not gitconfig_path.exists() or not yes_no('do you wish to use the base configuration provided?'):
        return config

    base_config = ConfigParser()
    base_config.read(gitconfig_path)

    for section in base_config.sections():
        if section not in config:
            config[section] = {}
        for key, value in base_config.items(section):
            config[section][key] = value

    return config


def get_ssh_key(config: GitConfig) -> GitConfig:
    """
    Create or add an SSH key.

    Creates `~/.ssh/github` and corresponding `~/.ssh/config` entry if they do not exist.
    Tests connection to github.com with key.
    :param config: User configuration with valid email
    :return: User configuration with SSH key
    """
    if not yes_no('would you like to create an ssh key?'):
        return config

    ssh_dir = Path(Path.home(), '.ssh')
    ssh_key_path = Path(ssh_dir, 'github')
    if not ssh_key_path.exists():
        run(f'ssh-keygen -t ed25519 -b 4096 -C "{config["user"]["email"]}" -f "{ssh_key_path}" -N ""')
        run('eval $(ssh-agent -s)')
        run(f'ssh-add {ssh_key_path}')
    print(f'ssh key at {ssh_key_path}:\n')
    print(run(f'cat {ssh_key_path}.pub'))
    print('\ncopy the above public key and add it to your github account at '
          'https://github.com/settings/keys as an ssh key')

    added = False
    while not added:
        added = yes_no('has the key been added to your account?')

    ssh_config_entry = """
    Host github.com
        Hostname github.com
        IdentityFile ~/.ssh/github
        IdentitiesOnly yes
        AddKeysToAgent yes
    """

    ssh_config_path = Path(ssh_dir, 'config')
    if not ssh_config_path.exists():
        ssh_config_path.parent.mkdir(exist_ok=True, parents=True)

    if ssh_config_path.exists():
        with open(ssh_config_path, 'r') as file:
            current_config = file.read()
    else:
        current_config = ""

    if ssh_config_entry.strip() not in current_config:
        with open(ssh_config_path, 'a') as file:
            file.write(ssh_config_entry)

    verified = False
    while not verified:
        ssh_test_result = run('ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -T git@github.com',
                              simple=True)
        if ('successfully authenticated' in ssh_test_result.stderr
                or 'successfully authenticated' in ssh_test_result.stdout):
            print('ssh key verified')
            verified = True
        else:
            print('ssh connection failed, check your ssh key configuration before proceeding')
            again = False
            while not again:
                again = yes_no('would you like to try again?')

    return config


def get_gpg_key_ids() -> list[str]:
    """
    Retrieve a list of gpg key ids
    :return: list of gpg long identifiers
    """
    keys_output = run('gpg --list-secret-keys --keyid-format LONG')
    key_ids = []
    for line in keys_output.split('\n'):
        if 'sec' in line:
            parts = line.split('/')
            if len(parts) > 1:
                key_id = parts[1].split(' ')[0]
                key_ids.append(key_id)
    return key_ids


def gpg_key_add_to_account(key_id: str) -> None:
    """
    Prompts user to add gpg key to github account
    :param key_id: Key ID to add to account
    :return: None
    """
    print('gpg public key:\n')
    print(run(f'gpg --armor --export {key_id}'))
    print('\ncopy the above gpg public key and add it to your github account at '
          'https://github.com/settings/keys as a gpg key')

    added = False
    while not added:
        added = yes_no('has the key been added to your account?')


def new_gpg_key(config: GitConfig, init_keys: list[str]) -> str:
    """
    Create a new gpg key given the configuration and initial list of gpg keys
    :param config: Configuration with valid user name and email
    :param init_keys: List of existing gpg keys
    :return: The created key's id
    """
    pass1 = ""
    pass2 = "none"
    while pass1 != pass2:
        pass1 = getpass("enter a passphrase for the gpg key: ")
        pass2 = getpass("confirm passphrase: ")
    passphrase = pass1

    print('creating new gpg key, this may take a few seconds...')

    gpg_input = f"""
    Key-Type: default
    Key-Length: 4096
    Subkey-Type: default
    Subkey-Length: 4096
    Name-Real: {config['user']['name']}
    Name-Email: {config['user']['email']}
    Expire-Date: 0
    Passphrase: {passphrase}
    Key-Curve: Ed25519
    Subkey-Curve: Ed25519
    %commit
    %echo done
    """

    gpg_input_path = Path(Path.home(), 'gpg_input.txt')
    with open(gpg_input_path, 'w') as file:
        file.write(gpg_input)
    run(f'gpg --batch --generate-key {gpg_input_path}')
    os.remove(gpg_input_path)

    key_id = set(get_gpg_key_ids()) - set(init_keys)
    if len(key_id) == 0:
        raise RuntimeError(f'no gpg keys created for {config["user"]["name"]}')
    elif len(key_id) > 1:
        raise RuntimeError(f'multiple gpg keys created for {config["user"]["name"]}')
    key_id = list(key_id)[0]

    gpg_key_add_to_account(key_id)

    return key_id


def get_gpg_key(config: GitConfig) -> GitConfig:
    """
    Get gpg key for user
    :param config: Valid git config with valid name and email
    :return: Valid git config with gpg settings
    """
    if not yes_no('would you like to create a gpg key?'):
        return config

    init_keys = get_gpg_key_ids()
    key_id = None

    if len(init_keys) > 1:
        print('the following gpg keys already exist:')
        for i, key in enumerate(init_keys):
            print(f'\t{i+1}) {key}')
        registered = yes_no('has one of these keys already been registered on https://github.com/settings/keys?')
        if not registered:
            use_existing = yes_no('would you like to use one of these keys?')
            if use_existing:
                key = None
                while key not in init_keys:
                    key = get_valid("please enter the desired key's id and it will be used as the signing key")
                    try:
                        idx = int(key)
                        key = init_keys[idx]
                    except:
                        key = key
                key_id = key
                gpg_key_add_to_account(key_id)
        else:  # key has been registered
            key = None
            while key not in init_keys:
                key = get_valid('since one of the keys has been registered, '
                                'please enter its id and it will be used as the signing key')
                try:
                    idx = int(key)
                    key = init_keys[idx]
                except:
                    key = key
            key_id = key
    elif len(init_keys) == 1:
        use_existing = yes_no(f'gpg key {init_keys[0]} already exists, '
                              'do you want to use it?')
        if use_existing:
            key_id = init_keys[0]
            registered = yes_no('is it registered on https://github.com/settings/keys?')
            if not registered:
                gpg_key_add_to_account(key_id)

    if key_id is None:
        key_id = new_gpg_key(config, init_keys)

    config['user']['signingkey'] = key_id

    use_by_default = yes_no('would you like to use your gpg key on commits by default?')
    config['commit'] = {
        'gpgsign': 'true' if use_by_default else 'false',
    }

    return config


def write_config(config: GitConfig) -> None:
    """
    Write git configuration to file
    :param config: Valid git configuration to be written
    :return: None
    """
    gitconfig = ConfigParser()
    gitconfig_path = Path(Path.home(), '.gitconfig')

    for section, values in config.items():
        gitconfig[section] = values

    with open(gitconfig_path, 'w') as handle:
        gitconfig.write(handle)


def main() -> None:
    """
    Driver function
    :return: None
    """
    check_git_installed()
    config = get_basic_config()
    config = get_base_config(config)
    config = get_ssh_key(config)
    config = get_gpg_key(config)
    write_config(config)


# Execute script
if __name__ == "__main__":
    main()
