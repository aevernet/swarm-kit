#!/usr/bin/env bash
#
# ==================================================================
# setup.sh
# ==================================================================
# Installs dependencies, replaces details in files for new project
# Usage:
#   bash "scripts/setup.sh"
# ==================================================================
# REQUIREMENTS
# ==================================================================
# Ensure the following packages are installed:
#   - git
#   - curl
#   - node
#   - npm
#   - standard-version
# ==================================================================

set -eu

if [[ -z "$baseDir" ]]; then
    declare -gx baseDir
    baseDir="$(dirname "$(realpath "$0")")"
fi

if [ -f "$baseDir/.env" ]; then
    bash "$baseDir"/.env
else
    bash "$baseDir"/.env.dist
fi

if [ -f "$baseDir/scripts/functions.sh" ]; then
    bash "$baseDir"/scripts/functions.sh
else
    echo "ERROR: Unable to find functions file"
    exit 1
fi

TOOLS=(
    "git"
    "curl"
    "node"
    "npm"
    "standard-version"
)

help() {
    echo
    echo "A script to setup a new project"
    echo
    echo "NOTE: You should copy .env.dist to .env and provide config options first"
    echo
    echo "Usage:"
    echo
    echo "      npm run setup"
    echo "- or -"
    echo "      bash scripts/setup.sh"
    echo
}

installTool() {
    tool="$1"

    case "$tool" in
        git)
            sudo apt install -y git
            ;;
        curl)
            sudo apt install -y curl
            ;;
        node)
            cd ~ || exit 1
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
            export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
            nvm install 'lts/*' --latest-npm
            ;;
        standard-version)
            npm i -g standard-version
            ;;
    esac
}

checkCmd() {
    if ! command -v "$1"; then
        installTool "$1"
    fi
}

check() {
    if [[ ! -f "$baseDir"/.env ]]; then
        echo "ERROR: You must first create a .env file.  Use .env.dist as a template"
        exit 1
    fi

    for i in "${!TOOLS[@]}"; do
        checkCmd "${TOOLS[$i]}"
    done
}

main() {
    check

    # replace variables in .github/* files
    find "$baseDir"/.github/ -type f -name "*" -print0 | xargs -0 sed -i "s/admin@ragdata.dev/${ADMIN_EMAIL}/g"
    find "$baseDir"/.github/ -type f -name "*" -print0 | xargs -0 sed -i "s/security@ragdata.dev/${SECURITY_EMAIL}/g"
    find "$baseDir"/.github/ -type f -name "*" -print0 | xargs -0 sed -i "s/Ragdata/${REPO_OWNER}/g"

    rm -f "$baseDir"/README.md 2>/dev/null || :                                 # remove the README file
    rm -f "$baseDir"/LICENSE 2>/dev/null || :                                   # remove the LICENSE file
    rm -f "$baseDir"/COPYRIGHT 2>/dev/null || :                                 # remove the COPYRIGHT file
    rm -f "$baseDir"/package.json 2>/dev/null || :                              # remove the package.json file
    rm -rf "$baseDir"/tests 2>/dev/null || :                                    # remove the tests folder
    rm -rf "$baseDir"/.github/workflows 2>/dev/null || :                        # remove the .github/workflows folder
    rm -f "$baseDir"/.github/ISSUE_TEMPLATE/config.yml 2>/dev/null || :         # remove the .github/ISSUE_TEMPLATE/config.yml file
    rm -f "$baseDir"/.github/SUPPORT.md 2>/dev/null || :                        # remove the .github/SUPPORT.md file

    writeREADME
    writeLICENSE
    writeCOPYRIGHT
    writePACKAGE
    writeCONFIG
    writeSUPPORT

    if [[ ! -d "$baseDir"/.git ]]; then
        # initialise git repo
        git init
    fi

    git add .
    git commit -m "feat: initial commit"

    # self-remove this script
    rm -f "$baseDir"/scripts/functions.sh
    rm -f "$baseDir"/scripts/setup.sh
}

while (($#)); do
    opt="$1"
    case "$opt" in
        -h | --help)
            help
            exit 0
            ;;
        *)
            help
            exit 1
            ;;
    esac
done
