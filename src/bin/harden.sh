#!/usr/bin/env bash
# shellcheck disable=SC2050
# shellcheck disable=SC2057
# ==================================================================
# src/bin/harden.sh
# ==================================================================
# Swarm-Kit - Self-Hosted Docker Swarm Cookbook
#
# File:         src/bin/harden.sh
# Author:       Ragdata
# Date:         09/01/2023
# License:      MIT License
# Copyright:    Copyright © 2022-2023 Darren Poulton (Ragdata)
# ==================================================================
# Improves security for a server with a fresh install of Ubuntu 20.04+
# Usage:
#   npm run harden
# - or -
#   bash src/bin/harden.sh
# ==================================================================

# preserve $PWD
[[ -z "$rootPath" ]] && declare -gx rootPath="$PWD"

set -eu

set -a
# load environment variables
[[ -f "$rootPath/.env" ]] && source "$rootPath/.env" || source "$rootPath/.env.dist";
set +a

# load bash-bits
if [[ -f "$SK_LIB/bb-common_loader.sh" ]]; then
    source "$SK_LIB/bb-common_loader.sh"
else
    echo "ERROR :: Swarm-Kit requires Bash-Bits to be installed"
    exit 1
fi

# initialise logger
initLog "$SK_LOG/harden"

# sanity checks
checkBash
checkRoot

help() {
    echo
    echo "A small script to secure a server running Ubuntu"
    echo
    echo "Usage:"
    echo
    echo "      npm run harden <options>"
    echo "- or -"
    echo "      bash src/bin/harden.sh <options>"
    echo
    echo "Options:"
    echo "      -h, --help          Display this help information"
    echo
}

main() {
    clear

    echoLog "Securing This Server" --color=yellow
    echoLog "line"
    echoLog "spacer"

    echoLog "Creating Administrative User"
    source "$PWD"/src/scripts/elem/user
    user-install

    source "$PWD"/src/scripts/elem/ufw
    ufw-config

    source "$PWD"/src/scripts/elem/sshd
    sshd-config

    source "$PWD"/src/scripts/elem/mfa
    [[ ! command -v google-authenticator ]] && mfa-install

    echoLog "Securing Shared Memory"
    echo ": /tmpdisk    /tmp    ext4    loop,nosuid,noexec,rw   0 0" >> /etc/fstab

    echoLog "Securing /tmp"
    fallocate -l 1G /tmpdisk
    mkfs.ext4 /tmpdisk
    chmod 0600 /tmpdisk

    mount -o loop,noexec,nosuid,rw /tmpdisk /tmp
    chmod 1777 /tmp

    echo ": /tmpdisk    /tmp    ext4    loop,nosuid,noexec,rw   0 0" >> /etc/fstab

    echoLog "Securing /var/tmp"
    mv /var/tmp /var/tmpold
    ln -s /tmp /var/tmp
    cp -prf /var/tmpold/* /tmp/
    rm -rf /var/tmpold/

    echoLog "Setting Process Limits"
    echo "${REGISTRY[SYSUSER]}  hard    nproc   100" >> /etc/security/limits.conf
    echo "${REGISTRY[MYUSER]}  hard    nproc   100" >> /etc/security/limits.conf

    echoLog "Disabling IP Spoofing"
    sed -i 's/order hosts,bind/order bind,hosts/' /etc/host.conf
    echo "nospoof on" >> /etc/host.conf

    source "$PWD"/src/scripts/elem/fail2ban
    fail2ban-install
    fail2ban-config


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
