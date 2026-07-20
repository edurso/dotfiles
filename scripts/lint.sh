#!/usr/bin/env bash
#
# run the same lint checks CI runs, locally, before pushing.
# requires shellcheck and ansible-lint to be on PATH.

set -e
set -o pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "running shellcheck..."
shellcheck "$ROOT/install.sh" "$ROOT"/scripts/*.sh

echo "running ansible-lint..."
ansible-galaxy collection install -r "$ROOT/ansible/requirements.yml"
ansible-lint --profile min "$ROOT/ansible"

echo "lint passed"
