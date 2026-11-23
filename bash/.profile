# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

BITCOIN="/home/ecavero/bitcoin-31.1/bin/"
PATH="$BITCOIN:$PATH"

ECLAIR="/home/ecavero/eclair-node-0.14.5-01384e9/bin"
PATH="$ECLAIR:$PATH"


FLYWAY="/home/ecavero/flyway-13.13.0"
PATH="$FLYWAY:$PATH"

SQLLINE="/home/ecavero/sqlline-sqlline-1.12.0/bin"
PATH="$SQLLINE:$PATH"

export SQUEEZE_PLAYER="SoftSqueeze"

# Created by `pipx` on 2024-12-14 17:44:52
export PATH="$PATH:/home/ecavero/.local/bin"

# Added by swiftly
. "/home/ecavero/.local/share/swiftly/env.sh"
# >>> coursier install directory >>>
export PATH="$PATH:/home/ecavero/.local/share/coursier/bin"
# <<< coursier install directory <<<

# Load secrets (not tracked by git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
