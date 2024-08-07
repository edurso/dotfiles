# dotfiles

@edurso's dotfiles

> **IMPORTANT:** These are still buggy and thus under very active development.

## Installation

1. Install `git`
2. Clone the repository (via https, `git clone https://github.com/edurso/dotfiles.git`) into the home directory
3. Make scripts executable with `chmod +x git.py install.sh`
4. Configure git (`./git.py` helps with this)
    - Optionally, switch remote to `ssh` with `git remote set-url origin git@github.com:edurso/dotfiles.git`
5. Run `sudo ./install.sh`
    - Note that the configuration steps of the installer are interactive, and will install ansible if ran as `sudo`
    - Run `./install.sh -h` for custom install options
6. Reboot when prompted

## Organization

Dotfile "packages" are listed in the root directory of the project and are managed with [GNU Stow](https://www.gnu.org/software/stow/). 
The installation script (`install.sh`) is merely a wrapper around the playbooks provided in `ansible/`. Together, these tools
perform all the necessary input parsing and setup as defined by the user.
