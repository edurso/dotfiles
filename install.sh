#!/usr/bin/env bash

# exit on error
set -e
set -o pipefail

# display constant
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly NC='\033[0m'

# help function
function display_help {
    echo -e "${BLUE}Usage: [sudo] $0 [options]${NC}"
    echo -e
    echo -e "Options:"
    echo -e "  -v, --verbose      verbose output"
    echo -e "  -b, --bare         bare installation"
    echo -e "  -s, --shell        ignore shell configurations"
    echo -e "  -t, --toolchain    ignore toolchain configurations"
    echo -e "  -d, --desktop      ignore desktop configurations"
    echo -e "  -h, --help         display this help message"
    echo -e
    exit 1
}

# function to allow the user to select to continue execution
function select_continue {
	while true; do
		echo -e "${YELLOW}do you wish to continue? (y/n) ${NC}"
		read -p "" yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) echo -e "${RED}answer yes (y) or no (n)${NC}";;
		esac
	done
}

# parse command line args
declare -A vars
vars[verbose]=false
vars[shell]=true
vars[toolchain]=true
vars[desktop]=true
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--verbose)
			echo -e "${BLUE}configuring verbose roles${NC}"
            vars[verbose]=true
            ;;
        -b|--bare)
			echo -e "${YELLOW}running bare installation${NC}"
            vars[shell]=false
			vars[toolchain]=false
			vars[desktop]=false
            break
            ;;
        -h|--help)
            display_help
            ;;
        -s|--shell)
			echo -e "${BLUE}running without shell configurations${NC}"
            vars[shell]=false
            ;;
        -t|--toolchain)
			echo -e "${BLUE}running without toolchain configurations${NC}"
            vars[toolchain]=false
            ;;
        -d|--desktop)
			echo -e "${BLUE}running without desktop configurations${NC}"
            vars[desktop]=false
            ;;
        *)
            echo -e "${RED}unknown option: $1${NC}"
            ;;
    esac
    shift
done

# check sudo
vars[is_sudo]=true
if [ "$(id -u)" -ne 0 ]; then
	vars[is_sudo]=false
	HOME=$(getent passwd "$USER" | cut -d: -f6)
	GRP=$(basename "$HOME")
    echo -e "${YELLOW}sudo was not used, though recommended${NC}"
	select_continue
else
	vars[is_sudo]=true
	HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
	# shellcheck disable=SC2034
	GRP=$(basename "$HOME")
	USER="$SUDO_USER"
fi

# check ssh keys
if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/github" ]; then
	echo -e "${GREEN}ssh keys properly configured${NC}"
else
	echo -e "${RED}ssh keys are not configured, cannot verify dotfiles${NC}"
	echo -e "${RED}to fix, run \`python3 git.py\` and follow prompts before attempting reinstall${NC}"
	exit 1
fi

# check distro and platform
echo -e "${BLUE}checking system configuration ...${NC}"
if ! grep -qi "ubuntu" /etc/os-release; then
	echo -e "${RED}this script is designed for ubuntu systems only${NC}"
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
echo -e "${BLUE}configuring environment for $disp_wsl ubuntu ${vars[ubuntu_release]}${NC}"

# check if ansible is installed
ansible_installed=true
if ! command -v ansible-playbook &> /dev/null; then
	if [ "${vars[is_sudo]}" = false ]; then
		echo -e "${RED}ansible is not installed - install or run as 'sudo'${NC}"
		exit 1
	fi
	ansible_installed=false
fi

# check if git is installed
git_installed=true
if ! command -v git &> /dev/null; then
	if [ "${vars[is_sudo]}" = false ]; then
		echo -e "${RED}git is not installed - install or run as 'sudo'${NC}"
		exit 1
	fi
	git_installed=false
fi

# install ppas
if [ "${vars[is_sudo]}" = true ]; then
	if [ "$ansible_installed" = false ] || [ "$git_installed" = false ]; then
		PPAS=(
			ansible/ansible
			git-core/ppa
		)
		NEED_APT_UPDATE=false
		for PPA in "${PPAS[@]}"; do
			if ! grep -q "^deb .*${PPA}" /etc/apt/sources.list /etc/apt/sources.list.d/*;
			then
				echo -e "${BLUE}adding ppa: ${PPA}${NC}"
				sudo apt-add-repository ppa:"${PPA}" -y
				NEED_APT_UPDATE=true
			fi
		done
		if [ "$NEED_APT_UPDATE" = true ]; then
			sudo apt update
		fi
		# install ansible and git
		sudo apt install -y ansible git
		ansible_installed=true
		git_installed=true
	fi
fi

# exit if dependencies are not installed
if [ "$ansible_installed" = false ] || [ "$git_installed" = false ]; then
	exit 1
fi

# clone or update repository
readonly REPO_URL="git@github.com:edurso/dotfiles.git"
readonly REPO_DIR="$HOME/dotfiles"
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    echo -e "${BLUE}dotfiles repository exists, updating${NC}"
	if [ "${vars[is_sudo]}" = true ]; then
		GIT_SSH_COMMAND='ssh -i "$HOME/.ssh/github" -o IdentitiesOnly=yes' git pull
	else
		git pull
	fi
else
    echo -e "${BLUE}cloning ${REPO_URL} into ${REPO_DIR}${NC}"
	if [ "${vars[is_sudo]}" = true ]; then
		GIT_SSH_COMMAND='ssh -i "$HOME/.ssh/github" -o IdentitiesOnly=yes' git clone "$REPO_URL"
	else
		git clone "$REPO_URL"
	fi
fi

# build ansible params list
ansible_params=""
for key in "${!vars[@]}"; do
    ansible_params+="$key=${vars[$key]} "
done

# run ansible playbook
echo -e "${BLUE}install parameters: ${ansible_params}${NC}"
echo -e "${YELLOW}do you wish to proceed with installation?${NC}"; select_continue
ansible-playbook -i "localhost," -c local "$REPO_DIR/ansible/setup.yml" -e "$ansible_params"

# change ownership of installed directories if ran as sudo
if [ "${vars[is_sudo]}" = true ]; then
	if [ -d "$HOME" ]; then
		echo -e "${BLUE}user ownership of $HOME ...${NC}"
		sudo chown -R "$USER":"$GRP" "$HOME"
	fi
fi

# prompt reboot
echo -e "${GREEN}configuration finished successfully${NC}"
echo -e "${GREEN}please reboot now to complete installation${NC}"
while true; do
	echo -e "${BLUE}reboot now? (y/n): ${NC}"
    read -p "" choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
    if [[ "$choice" == "y" ]]; then
        echo -e "${GREEN}rebooting now...${NC}"
        reboot
        break
    elif [[ "$choice" == "n" ]]; then
        echo -e "${YELLOW}reboot canceled, please reboot soon${NC}"
        break
    else
        echo -e "${RED}invalid input${NC}"
    fi
done
