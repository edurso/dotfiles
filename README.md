# dotfiles

@edurso's dotfiles

> **IMPORTANT:** These are still buggy and thus under very active development.

## Installation

1. Install `git`
2. Clone the repository into the home directory
3. Make scripts executable with `chmod +x git.py install.sh`
4. Configure git (`./git.py` helps with this)
5. Run `sudo ./install.sh`
6. Reboot when prompted

## Organization

Dotfile "packages" are listed in the root directory of the project and are managed with [GNU Stow](https://www.gnu.org/software/stow/). 
The installation script (`install.sh`) is merely a wrapper around the playbooks provided in `ansible/`. Together, these tools
perform all the necessary input parsing and setup as defined by the user.
