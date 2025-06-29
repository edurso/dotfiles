#!/usr/bin/env bash

# define relative directory paths
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT/scripts"

# include necessary fail conditions and headers
source "$SCRIPTS_DIR/init.sh"

# set IS_SUDO
source "$SCRIPTS_DIR/sudo.sh"

# enforce SSH key configuration
source "$SCRIPTS_DIR/ssh.sh"

# vars to pass to ansible?
declare -A vars
vars[verbose]=false
vars[is_sudo]=$IS_SUDO

# check distro and platform
display -b "checking system configuration ..."
if ! grep -qi "ubuntu" /etc/os-release; then
    display -r "this script is designed for ubuntu systems only"
    exit 1
fi
vars[ubuntu_release]=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)
vars[wsl]=false
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
    vars[wsl]=true
fi

# display distro and platform
disp_wsl=''
if [ "${vars[wsl]}" = true ]; then
    disp_wsl='wsl'
fi
display -b "configuring environment for the following parameters: $disp_wsl ubuntu ${vars[ubuntu_release]}"

# check if ansible is installed
ansible_installed=true
if ! command -v ansible-playbook &> /dev/null; then
    if [ "${vars[is_sudo]}" = false ]; then
        display -r "ansible is not installed - install or run as 'sudo'"
        exit 1
    fi
    sudo apt install ansible
fi

# check if git is installed
git_installed=true
if ! command -v git &> /dev/null; then
    if [ "${vars[is_sudo]}" = false ]; then
        display -r "git is not installed - install or run as 'sudo'"
        exit 1
    fi
    sudo apt install git
fi

# exit if dependencies are not installed
if [ "$ansible_installed" = false ] || [ "$git_installed" = false ]; then
    display -r "please ensure both ansible and git are installed before proceeding"
    exit 1
fi

# build ansible params list
ansible_params=""
for key in "${!vars[@]}"; do
    ansible_params+="$key=${vars[$key]} "
done

# run ansible playbooks
readonly REPO_DIR="$HOME/dotfiles"
display -b "install parameters: ${ansible_params}"
display -y "do you wish to proceed with installation?"; select_continue
display -b "installing base components..."
ansible-playbook -i "localhost," -c local "$REPO_DIR/ansible/initial.yml" -e "$ansible_params"

while true; do
    display -b "install development tools? (y/n): "
    read -rp "" choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
    if [[ "$choice" == "y" ]]; then
        display -g "installing development tools..."
        ansible-playbook -i "localhost," -c local "$REPO_DIR/ansible/devel.yml" -e "$ansible_params"
        break
    elif [[ "$choice" == "n" ]]; then
        display -y "skipping development tools"
        break
    else
        display -r "invalid input"
    fi
done

while true; do
    display -b "install desktop tools? (y/n): "
    read -rp "" choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
    if [[ "$choice" == "y" ]]; then
        display -g "installing desktop tools..."
        ansible-playbook -i "localhost," -c local "$REPO_DIR/ansible/desktop.yml" -e "$ansible_params"
        break
    elif [[ "$choice" == "n" ]]; then
        display -y "skipping desktop tools"
        break
    else
        display -r "invalid input"
    fi
done

# change ownership of installed directories if ran as sudo
if [ "${vars[is_sudo]}" = true ]; then
    if [ -d "$HOME" ]; then
        display -b "user ownership of $HOME ..."
        sudo chown -R "$USER":"$GRP" "$HOME"
    fi
fi

# update & upgrade
display -b "updating apt packages..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null

# install fonts
is_font_installed() {
    fc-list | grep "JetBrains" > /dev/null
}

display -b "installing jetbrains mono fonts..."
if is_font_installed; then
    display -g "jetbrains mono fonts are already installed"
else
    display -b "installing jetbrains mono fonts..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
    if is_font_installed; then
        display -g "jetbrains mono fonts installed successfully"
    else
        display -r "failed to install jetbrains mono fonts"
    fi
fi

# prompt reboot
display -g "configuration finished successfully"
display -g "please reboot now to complete installation"
while true; do
    display -b "reboot now? (y/n): "
    read -rp "" choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
    if [[ "$choice" == "y" ]]; then
        display -g "rebooting now..."
        reboot
        break
    elif [[ "$choice" == "n" ]]; then
        display -y "reboot canceled, please reboot soon"
        break
    else
        display -r "invalid input"
    fi
done
