#!/usr/bin/env bash

# from https://github.com/thackl/dropbox-dual-account-setup/blob/master/dropboxd-accounts

pushd . > /dev/null
DIR="${BASH_SOURCE[0]}"

while [ -h "$DIR" ]; do
	cd "$(dirname "$DIR")"
	DIR="$(readlink "$(basename "$DIR")")"
done

cd "$(dirname "$DIR")"
DIR="$(pwd)/"
popd > /dev/null

# start dropboxd for each account with pseudo home
for ACC in `find "$DIR" -mindepth 1 -maxdepth 1 -type d` ; do
	ACC=`echo "$ACC" | tr -s '/'`
	HOME=$ACC $ACC/.dropbox-dist/dropboxd &
done;

