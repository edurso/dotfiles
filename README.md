# dotfiles

[@edurso](https://edurso.com)'s dotfiles

> **IMPORTANT:** These are still under very active development and thus very buggy.

## Organization

Dotfile "packages" are listed in the root directory of the project and are managed with [GNU Stow](https://www.gnu.org/software/stow/).
The installation script (`install.sh`) is merely a wrapper around the playbooks provided in `ansible/`. Together, these tools
perform all the necessary input parsing and setup as defined by the user. Ansible handles the installation of several packages
and applications defined by the installation script that do not necessary have dotfiles.

## Installation

1. Install `git`
2. Clone the repository (via https, `git clone https://github.com/edurso/dotfiles.git`) into the home directory
3. Configure git (`./git.py` helps with this)
4. Run `sudo ./install.sh`
    - Note that the configuration steps of the installer are interactive, and will install ansible if ran as `sudo`
    - There are 3 installation phases: the base components, the development components (i.e. ides, etc.), and the desktop components (i.e.) general applications.
5. Reboot when prompted

## Additional Configuration

### Fonts

[JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) is installed through the insallation script, and is set as the default font for
[alacritty](https://alacritty.org/). This font can be added to the rest of the system via `gnome-tweaks`.

### Dropbox

Due to the interactive dropbox configuration process, it is not completely configured by the installer.

Dropbox utilities are copied to `~/dropbox`.

The `init.sh` script starts the dropbox installation process.
It does this for two accounts (personal and umich) and will launch a browser window with dropbox for authentication.

The `dropbox.sh` will launch all dropbox dameon's installed under `~/dropbox` on system startup.
Thus, it should be added to the list of system startup applications.

### Obsidian

The Obsidian package is not available on `apt` or as a ppa, so it needs to be installed manually.
Find the latest released debian package [here](https://github.com/obsidianmd/obsidian-releases/releases/latest), and install with `sudo apt install ./<download-name>.deb`

### NordVPN

The NordVPN installation script can be found [here](https://nordvpn.com/download/linux/#install-nordvpn).

### Desktop

Ubuntu has some annoying desktop settings, fixes for them enumerated below.

- Default directories (`~/Downloads`, `~/Documents`, etc.) can be [renamed or disabled](https://superuser.com/questions/223918/ubuntu-permanently-remove-videos-and-public)
