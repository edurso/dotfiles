# dotfiles

@edurso's dotfiles

> **IMPORTANT:** These are still under very active development and thus very buggy.

## Installation

1. Install `git`
2. Clone the repository (via https, `git clone https://github.com/edurso/dotfiles.git`) into the home directory
3. Configure git (`./git.py` helps with this)
4. Run `sudo ./install.sh`
    - Note that the configuration steps of the installer are interactive, and will install ansible if ran as `sudo`
    - Run `./install.sh -h` for custom install options
5. Reboot when prompted

## Fonts

Haven't added these to installation candidate yet, but [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono) is a nice font.
Once installed as shown below, it can be added to Ubuntu via `gnome-tweaks`.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
```

## Desktop

Ubuntu has some annoying desktop settings, fixes for them enumerated below.

- Default directories (`~/Downloads`, `~/Documents`, etc.) can be [renamed or disabled](https://superuser.com/questions/223918/ubuntu-permanently-remove-videos-and-public)

## Organization

Dotfile "packages" are listed in the root directory of the project and are managed with [GNU Stow](https://www.gnu.org/software/stow/). 
The installation script (`install.sh`) is merely a wrapper around the playbooks provided in `ansible/`. Together, these tools
perform all the necessary input parsing and setup as defined by the user. Ansible handles the installation of several packages 
and applications defined by the installation script that do not necessary have dotfiles.
