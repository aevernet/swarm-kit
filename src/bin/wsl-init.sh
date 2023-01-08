#!/usr/bin/env bash
# shellcheck disable=SC2154
# ==================================================================
# bin/wsl-init.sh
# ==================================================================
# Swarm-Kit - Self-Hosted Docker Swarm Cookbook
#
# File:         bin/wsl-init.sh
# Author:       Ragdata
# Date:         08/01/2023
# License:      MIT License
# Copyright:    Copyright © 2022-2023 Darren Poulton (Ragdata)
# ==================================================================
# Sets up and secures a fresh WSL2 Ubuntu 20.04+ install
# Usage:
#   bash "src/bin/wsl-init.sh"
# ==================================================================
# REQUIREMENTS
# ==================================================================
# Ensure that you have installed the Bash Bits project first
# ==================================================================

# preserve $PWD
[[ -z "$rootPath" ]] && declare -gx rootPath="$PWD"

# load environment variables
[[ -f "$rootPath/.env" ]] && source "$rootPath/.env" || source "$rootPath/.env.dist";

# load bash-bits
if [[ -f "$BB_LIB/bb-common_loader.sh" ]]; then
    source "$BB_LIB/bb-common_loader.sh"
else
    echo "ERROR :: Swarm-Kit requires Bash-Bits to be installed"
    exit 1
fi

# sanity checks
checkBash
checkRoot

# initialise logger
logInit wsl-init

# listen for continuation flag after reboot
if [[ -n "$1" ]]; then
    # when returning from reboot, remove the last line of .bashrc
    if [[ "$1" == "cont" ]]; then
        tail -n 1 "$HOME/.bashrc" | wc -c xargs -I {} truncate "$HOME/.bashrc" -s -{}
    fi
else
    if [[ "$(ps --no-headers -o comm 1)" == "init" ]]; then
        # on first execution, call the function which enables systemd for WSL2
        source "$PWD/src/scripts/elem/wsl-init"
        wsl-init-config
    fi
fi

loadSource "$SK_ELEM/repos"
