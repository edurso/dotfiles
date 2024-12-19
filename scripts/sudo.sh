#!/usr/bin/env bash

IS_SUDO=true

# determine if user is actively sudo
# set HOME, GRP, and USER vars accordingly
if [ "$(id -u)" -ne 0 ]; then
	IS_SUDO=false
	HOME=$(getent passwd "$USER" | cut -d: -f6)
	GRP=$(basename "$HOME")
    display -y "sudo was not used, though recommended"
	select_continue
else
	IS_SUDO=true
	HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
	# shellcheck disable=SC2034
	GRP=$(basename "$HOME")
	USER="$SUDO_USER"
fi
