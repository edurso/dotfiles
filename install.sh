#!/usr/bin/env bash

# exit on error
set -e
set -o pipefail

# display constant
readonly RED='\033[1;31m'
readonly BLUE='\033[1;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# help function
function display_help {
    echo "Usage: [sudo] $0 [options]"
    echo
    echo "Options:"
    echo "  -v, --verbose   flag for verbose ansible output"
    echo "  -d, --desktop   configure for desktop environments"
    echo "  -s, --shell     install shell script customizations"
    echo "  -h, --help      display this help message"
    echo
    exit 1
}

# parse command line args
declare -A vars
vars[desktop]=false
vars[shell]=false
vars[verbose]=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--verbose)
			echo -e "${BLUE}configuring verbose roles${NC}"
            vars[verbose]=true
            ;;
        -d|--desktop)
			echo -e "${BLUE}configuring desktop roles${NC}"
            vars[desktop]=true
            ;;
        -s|--shell)
			echo -e "${BLUE}configuring shell roles${NC}"
            vars[shell]=true
            ;;
        -h|--help)
            display_help
            ;;
        *)
            echo -e "${RED}unknown option: $1${NC}"
            display_help
            ;;
    esac
    shift
done

# distro info
if ! grep -qi "ubuntu" /etc/os-release; then
	echo -e "${RED}this script is designed for ubuntu systems only${NC}"
	exit 1
fi
vars[ubuntu_release]=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)
echo -e "${BLUE}configuring environment for ubuntu ${vars[ubuntu_release]}${NC}"

# check wsl
vars[wsl]=false
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null; then
	vars[wsl]=true
fi

# check sudo
echo -e "${BLUE}checking sudo ...${NC}"
vars[is_sudo]=true
if [ "$(id -u)" -ne 0 ]; then
	vars[is_sudo]=false
	HOME=$(getent passwd "$USER" | cut -d: -f6)
	GRP=$(basename "$HOME")
	USER="$USER"
    echo -e "${YELLOW}sudo was not used, though recommended${NC}"
else
	vars[is_sudo]=true
	HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
	GRP=$(basename "$HOME")
	USER="$SUDO_USER"
    echo -e "${BLUE}environment will be configured as admin${NC}"
fi

# force ssh keys
if [ "$production" = false ]; then
	echo -e "${BLUE}ensuring SSH keys are set up ...${NC}"
	if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
		echo -e "${RED}configure SSH keys for GitHub: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent${NC}"
		exit 1
	fi
fi

# check if ansible is installed
ansible_installed=true
if ! command -v ansible-playbook &> /dev/null; then
	echo "${RED}ansible is not installed - install or run as 'sudo'${NC}"
	ansible_installed=false
fi

# check if git is installed
git_installed=true
if ! command -v git &> /dev/null; then
	echo "${RED}git is not installed - install or run as 'sudo'${NC}"
	git_installed=false
fi

# install ppas
if [ "${vars[is_sudo]}" = true ]; then
	if [ "$ansible_installed" = false ] || [ "$git_installed" = false ]; then
		PPAS=(
			ansible/ansible
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
		# install aptitude, ansible, and git
		sudo apt install -y aptitude ansible git
		ansible_installed=true
		git_installed=true
	fi
fi

# exit if dependencies are not installed
if [ "$ansible_installed" = false ] || [ "$git_installed" = false ]; then
	exit 1
fi

# build ansible params list
ansible_params=""
for key in "${!vars[@]}"; do
    ansible_params+="$key=${vars[$key]} "
done

# clone or update repository
readonly REPO_URL="git@github.com:edurso/dotfiles.git"
readonly REPO_DIR="$HOME/dev/dotfiles"
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    echo -e "${BLUE}dotfiles repository exists, updating${NC}"
	if [ "${vars[is_sudo]}" = true ]; then
		GIT_SSH_COMMAND='ssh -i "$HOME/.ssh/id_ed25519" -o IdentitiesOnly=yes' git pull
	else
		git pull
	fi
else
    echo -e "${BLUE}cloning ${REPO_URL} into ${REPO_DIR}${NC}"
	if [ "${vars[is_sudo]}" = true ]; then
		GIT_SSH_COMMAND='ssh -i "$HOME/.ssh/id_ed25519" -o IdentitiesOnly=yes' git clone "$REPO_URL"
	else
		git clone "$REPO_URL"
	fi
fi

# run ansible playbook
echo -e "${BLUE}install parameters: ${ansible_params}${NC}"
exit
ansible-playbook -i "localhost," -c local "$REPO_DIR/ansible/env.yml" -e "$ansible_params"

# change ownership of installed directories if ran as sudo
if [ "${vars[is_sudo]}" = true ]; then
	if [ -d "$HOME" ]; then
		echo -e "${BLUE}user ownership of $HOME ...${NC}"
		sudo chown -R "$USER":"$GRP" "$HOME"
	fi
fi

# set shell to zsh
if [ "${vars[shell]}" = true ]; then
	echo -e "${BLUE}forcing shell to zsh ...${NC}"
	chsh --shell "$(which zsh)" "$USER"
fi
