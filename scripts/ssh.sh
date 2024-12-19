#!/usr/bin/env bash

# check ssh keys
matches=("$HOME/.ssh/github"*)
if [ -n "${matches[0]}" ] || [ -f "$HOME/.ssh/id_ed25519" ]; then
	display -g "ssh keys properly configured"
else
	display -r "ssh keys are not properly configured"
	display -r "to fix, run \`python3 git.py\` and follow prompts before attempting reinstall"
	exit 1
fi
