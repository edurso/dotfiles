# dotfiles

@edurso's dotfiles

## Installation

in progress

## Organization

Dotfile "packages" are listed in the root directory of the project and are managed with [GNU Stow](https://www.gnu.org/software/stow/). 
The installation script (`install.sh`) is merely a wrapper around the playbooks provided in `ansible/`. Together, these tools
perform all the necessary input parsing and setup as defined by the user.

