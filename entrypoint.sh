#!/bin/sh -l
set -e

PATH=$PATH:/usr/local/cargo/bin

if [ -n "$1" ]
then
    rustup set profile minimal
    rustup default "$1"
fi

if [ -n "$2" ]
then
    rustup target add "$2"
fi

if [ -n "$3" ]
then
    git config --global credential.helper store
    git config --global --replace-all url.https://github.com/.insteadOf ssh://git@github.com/
    git config --global --add url.https://github.com/.insteadOf git@github.com:

    echo "$3" > "$HOME/.git-credentials"
    chmod 600 "$HOME/.git-credentials"
fi

if [ -n "$4" ]
then
    mkdir -p "/root/.ssh"
    chmod 0700 "/root/.ssh"
    echo "${4}" > "/root/.ssh/id_rsa"
    chmod 0600 "/root/.ssh/id_rsa"
fi

if [ -n "$5" ]
then
    mkdir -p "/root/.ssh"
    chmod 0700 "/root/.ssh"
    echo "${5}" > "/root/.ssh/known_hosts"
    chmod 0600 "/root/.ssh/known_hosts"
fi

if [ -n "$6" ]
then
    export CARGO_NET_GIT_FETCH_WITH_CLI="$6"
fi

shift
shift
shift
shift
shift
shift

# Due to how github actions run containers we need to explicitly force colors
# as TTY detection fails inside them
export CARGO_TERM_COLOR="always"

cargo-deny $*
