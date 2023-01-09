#!/usr/bin/env bash
#
# ==================================================================
# src/bin/install.sh
# ==================================================================
# Swarm-Kit - Self-Hosted Docker Swarm Cookbook
#
# File:         src/bin/install.sh
# Author:       Ragdata
# Date:         08/01/2023
# License:      MIT License
# Copyright:    Copyright © 2022-2023 Darren Poulton (Ragdata)
# ==================================================================
# Installs Swarm-Kit onto a linux (Ubuntu) server and gets it ready to work
# Usage:
#   npm run install
#   - or -
#   bash "src/bin/install.sh"
# ==================================================================
# REQUIREMENTS
# ==================================================================
# Ensure that you have installed the Bash Bits project first
# ==================================================================

# preserve $PWD
[[ -z "$rootPath" ]] && declare -gx rootPath="$PWD"

set -eu

set -a
# load environment variables
[[ -f "$rootPath/.env" ]] && source "$rootPath/.env" || source "$rootPath/.env.dist";
set +a

# load bash-bits
if [[ -f "$BB_LIB/bb-common_loader.sh" ]]; then
    source "$BB_LIB/bb-common_loader.sh"
else
    echo "ERROR :: Swarm-Kit requires Bash-Bits to be installed"
    exit 1
fi

# initialise logger
initLog "$SK_LOG/install"

# sanity checks
checkBash
checkRoot

help() {
    echo
    echo "A small script to install Swarm-Kit on a server"
    echo
    echo "Usage:"
    echo
    echo "      npm run install <options>"
    echo "- or -"
    echo "      bash src/bin/install.sh <options>"
    echo
    echo "Options:"
    echo "      -h, --help          Display this help information"
    echo
}

createPaths() {
    # create system paths
    [[ ! -d "$SK_LIB" ]] && mkdir -p "$SK_LIB"
    [[ ! -d "$SK_BIN" ]] && mkdir -p "$SK_BIN"
    [[ ! -d "$SK_ETC" ]] && mkdir -p "$SK_ETC"
    [[ ! -d "$SK_OPT" ]] && mkdir -p "$SK_OPT"
    [[ ! -d "$SK_LOG" ]] && mkdir -p "$SK_LOG"

    # create sk paths
    [[ ! -d "$CFGDIR" ]] && mkdir -p "$CFGDIR"
    [[ ! -d "$INCDIR" ]] && mkdir -p "$INCDIR"
    [[ ! -d "$REGDIR" ]] && mkdir -p "$REGDIR"
    [[ ! -d "$DOCDIR" ]] && mkdir -p "$DOCDIR"
    [[ ! -d "$PKGDIR" ]] && mkdir -p "$PKGDIR"
    [[ ! -d "$SCRIPTS" ]] && mkdir -p "$SCRIPTS"
    [[ ! -d "$STACKS" ]] && mkdir -p "$STACKS"
    [[ ! -d "$ELEM" ]] && mkdir -p "$ELEM"
}

writeEnv() {
    echoLog "Writing global environment file"
    cat << EOF > /tmp/env.sh
# SYSTEM PATHS
SK_LIB='$SK_LIB'
SK_BIN='$SK_BIN'
SK_ETC='$SK_ETC'
SK_OPT='$SK_OPT'
SK_LOG='$SK_LOG'
# SK PATHS
CFGDIR='$CFGDIR'
INCDIR='$INCDIR'
REGDIR='$REGDIR'
DOCDIR='$DOCDIR'
SCRIPTS='$SK_OPT/scripts'
STACKS='$SK_OPT/stacks'
ELEM='$SCRIPTS/elem'
PKGDIR='$PKGDIR'
# FILE PATHS
DEF='$DEF'
DIS='$DIS'
NET='$NET'
PASSWORD='$PASSWORD'
EOF

    echoLog "Installing copy of global environment file in /etc/profile.d"
    sudo install -m 644 -g root -o root "/tmp/env.sh" "/etc/profile.d/sk-env.sh"

    echoLog "Writing copy of global environment variables to /etc/environment"
    while IFS= read -r line
    do
        key="${line%=*}"
        # if neither the variable name nor the line as a whole are there already, write the line
        if ! grep -q "${key}" /etc/environment && ! grep -q "${line}" /etc/environment; then
            echo "$line" >> /etc/environment
        # if the variable name is there but the value is different, then replace with the line
        elif grep -q "${key}" /etc/environment; then
            sed -i "s/$key=.*/$line/" /etc/environment
        fi
    done < /tmp/env.sh
    sudo rm -f /tmp/env.sh
}

report() {
    echo
    echoLog "DONE!" --color=yellow
    echo
    echo "Logfile: $SK_LOG/install"
    echo "Type 'cat $SK_LOG/install' to view on-screen now"
    echo
}

main() {
    clear

    echoLog "Installing Swarm-Kit Docker Swarm Cookbook" --color=yellow
    echoLog "line"
    echoLog "spacer"

    echoLog "Creating Required Paths"
    createPaths

    echoLog "Writing Global Environment Files"
    writeEnv

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing bin files"
    echoLog "separator"
    for file in "$PWD"/src/bin/*
    do
        if [[ -f "$file" ]]; then
            echoLog "$file"
            sudo install -m 775 -g root -o root "$file" "$SK_BIN/$file"
        fi
    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing etc files"
    echoLog "separator"
    for file in "$PWD"/src/etc/*
    do
        if [[ -f "$file" && "$file" != "bump.sh" ]]; then
            echoLog "$file"
            sudo install -m 775 -g root -o root "$file" "$SK_ETC/$file"
        fi
    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing config files"
    echoLog "separator"
    for file in "$PWD"/cfg/*
    do
        if [[ -f "$file" ]]; then
            echoLog "$file"
            sudo install -m 775 -g root -o root "$file" "$CFGDIR/$file"
        fi
    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing inc files"
    echoLog "separator"
    for file in "$PWD"/inc/*
    do
        if [[ -f "$file" ]]; then
            echoLog "$file"
            sudo install -m 777 -g root -o root "$file" "$INCDIR/$file"
        elif [[ -d "$file" ]]; then
            echoLog "spacer"
            echoLog "$file"
            echoLog "separator"
            for inc in "$PWD"/inc/"$file"/*
            do
                echoLog "$inc"
                sudo install -m 777 -g root -o root "$doc" "$INCDIR/$file/$inc"
            done
        fi
    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing Documentation"
    echoLog "separator"
    for file in "$PWD"/docs/*
    do
        if [[ -f "$file" ]]; then
            echoLog "$file"
            sudo install -m 777 -g root -o root "$file" "$DOCDIR/$file"
        elif [[ -d "$file" ]]; then
            echoLog "spacer"
            echoLog "$file"
            echoLog "separator"
            for doc in "$PWD"/docs/"$file"/*
            do
                echoLog "$doc"
                sudo install -m 777 -g root -o root "$doc" "$DOCDIR/$file/$doc"
            done
        fi
    done

#    echoLog "spacer"
#    echoLog "separator"
#    echoLog "Installing script files"
#    echoLog "separator"
#    for file in "$PWD"/src/scripts/*
#    do
#        if [[ -f "$file" ]]; then
#            echoLog "$file"
#            sudo install -m 775 -g root -o root "$file" "$SCRIPTS/$file"
#        fi
#    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing stack files"
    echoLog "separator"
    for dir in "$PWD"/src/scripts/stacks/*
    do
        if [[ -d "$dir" ]]; then
            echoLog "spacer"
            echoLog "$dir"
            echoLog "separator"
            for file in "$PWD"/src/scripts/stacks/"$dir"/*
            do
                echoLog "$file"
                sudo install -m 775 -g root -o root "$file" "$STACKS/$dir/$file"
            done
        fi
    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing element files"
    echoLog "separator"
    for file in "$PWD"/src/scripts/elem/*
    do
        if [[ -f "$file" ]]; then
            echoLog "$file"
            sudo install -m 775 -g root -o root "$file" "$ELEM/$file"
        fi
    done

    echoLog "spacer"
    echoLog "separator"
    echoLog "Installing package files"
    echoLog "separator"
    for file in "$PWD"/src/scripts/pkgs/*
    do
        if [[ -f "$file" ]]; then
            echoLog "$file"
            sudo install -m 775 -g root -o root "$file" "$PKGDIR/$file"
        fi
    done

    report
}

options=$(getopt -l "help" -o "h" -a -- "$@")

eval set --"$options"

while true
do
    case "$1" in
        -h|--help)
            help
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            errorExit "install.sh :: Invalid Argument '$1'"
            ;;
    esac
    shift
done

main
