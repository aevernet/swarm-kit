#!/usr/bin/env bash
#
# ==================================================================
# bump.sh
# ==================================================================
# Bumps version, creates changelog, tags, and release.
# Usage:
#   bash "scripts/bump.sh" \
#       --user 'username' \                 # required
#       --email 'user@example.com' \        # required
#       --type 'patch' \                    # [patch|minor|major]
#       --message 'bump to {{ version }}'   # optional
#       --branch 'master'                   # optional
#       --version 'version'                 # optional
#       --preview                           # optional
# ==================================================================
# REQUIREMENTS
# ==================================================================
# Ensure the following packages are installed:
#   - git
#   - standard-version
# ==================================================================

if [[ -z "$baseDir" ]]; then
    declare -gx baseDir
    baseDir="$(dirname "$(dirname "$(realpath "$0")")")"
fi

set -eu

set -a

if [ -f "$baseDir/.env" ]; then
    source "$baseDir"/.env
else
    source "$baseDir"/.env.dist
fi

set +a

WORKING_BRANCH="$(git branch --show-current)"
STAGING_BRANCH="$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"
PROD_BRANCH="master"

TYPE=""
MESSAGE=""
BRANCH=""

FILES=(
    "$baseDir/COPYRIGHT"
    "$baseDir/README.md"
    "$baseDir/package.json"
)

TOOLS=(
    "git"
    "standard-version"
)

help() {
    echo
    echo "A script to release a new version of a project"
    echo
    echo "Usage:"
    echo
    echo "      npm run release <options>"
    echo "- or -"
    echo "      bash scripts/bump.sh <options>"
    echo
    echo "Options:"
    echo "      -u, --user          Git user name       (optional)  Default: $USER_NAME"
    echo "      -e, --email         Git user email      (optional)  Default: $USER_EMAIL"
    echo "      -m, --message       Commit message      (optional)  Default: 'chore(release): release vX.X.X'"
    echo "      -b, --branch        Git branch          (optional)  Default: master"
    echo "      -t, --type          [patch|minor|major] (optional)  Default: patch"
    echo "                              - The 'type' argument is a special one:"
    echo "                                  - First Release: first-release"
    echo "                                  - Pre-Release: prerelease [optional name] - eg: prerelease alpha = 1.0.0-alpha.0"
    echo "                                  - Patch Release: patch"
    echo "                                  - Minor Release: minor"
    echo "                                  - Major Release: major"
    echo "                                  - Force Version: release-as [prerelease|minor|major|X.X.X] (where X.X.X is a version number)"
    echo "      -p, --preview       Preview Mode        (optional)  Default: false"
    echo "                              - branches will not be modified"
    echo
}

checkGit() {
    if [[ -n $(git status . -s) ]]; then
        echo "ERROR: Commit the staged files first, then run this command again"
        exit 1
    fi

    if [[ "$WORKING_BRANCH" != "$STAGING_BRANCH" && "$WORKING_BRANCH" != "$PATCH_STUB" ]]; then
        echo "ERROR: Please run on the master branch or patch branches"
        exit 1
    fi

    if [[ -z "$(git config --get user.email)" ]]; then
        git config --global user.name = "$USER_NAME"
        git config --global user.email = "$USER_EMAIL"
    fi
}

checkSrc() {
    if [[ ! -f "$1" && ! -d "$1" ]]; then
        echo "ERROR: Missing File '$1'!"
        exit 1
    fi
}

checkCmd() {
    if ! command -v "$1" &>/dev/null; then
        echo "ERROR: Command '$1' Not Found!"
        exit 1
    fi
}

check() {
    checkGit

    for i in "${!FILES[@]}"; do
        checkSrc "${FILES[$i]}"
    done

    for i in "${!TOOLS[@]}"; do
        checkCmd "${TOOLS[$i]}"
    done
}

bumpFile() {
    for i in "${!FILES[@]}"; do
        if [[ -f "${FILES[$i]}" ]]; then
            sed -i "s/v[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+/v$1/" "${FILES[$i]}"
        fi
    done
}

bump() {
    bumpFile "$1"

    if [[ "$TYPE" != "preview" && -n $(git status . -s) ]]; then
        if [[ -z "$MESSAGE" ]]; then MESSAGE="chore(release): release $1"; else MESSAGE="$MESSAGE $1"; fi
        git add .
        git commit -m "$MESSAGE"
    fi
}

standardVersion() {
    if [[ "$TYPE" == "preview" ]]; then
        standard-version --prerelease rc
    else
        standard-version "$TYPE"
    fi
}

standardVersionPlus() {
    temp_branch="master-mirror"
    temp_dir="$(mktemp -d)"

    git checkout -b "$temp_branch" "$PROD_BRANCH"
    git merge --no-ff --no-edit "$STAGING_BRANCH"

    standardVersion

    cp package.json CHANGELOG.md "$temp_dir"

    git checkout "$STAGING_BRANCH"
    git reset --hard HEAD           # undo changes from temp_branch
    mv "$temp_dir"/* .              # rewrite the changelog

    # clean up the temp stuff
    rm -rf "$temp_dir"
    git branch -D "$temp_branch"
}

release() {
    _version="$1"

    git checkout "$PROD_BRANCH"
    git merge --no-ff --no-edit "$WORKING_BRANCH"

    # create a new tag on production branch
    echo -e "Create tag v$_version\n"
    git tag "v$_version"

    # merge from patch branch to the staging branch
    # NOTE: This may break if conflicted and may require manual intervention
    if [[ "$WORKING_BRANCH" == "$PATCH_STUB" ]]; then
        git checkout "$STAGING_BRANCH"
        git merge --no-ff --no-edit "$WORKING_BRANCH"
        git branch -D "$WORKING_BRANCH"
    fi
}

main() {
    check

    if [[ "$WORKING_BRANCH" == "$STAGING_BRANCH" ]]; then
        standardVersionPlus
    else
        standardVersion
    fi

    # change heading of patch version to level 2 (a bug from `standard-version`)
    sed -i "s/^### \[/## \[/g" "$baseDir"/CHANGELOG.md

    _version="$(grep '"version":' package.json | sed 's/.*: "//;s/".*//')"

    echo -e "Bump version number to $_version\n"
    bump "$_version"

    if [[ "$TYPE" == "preview" ]]; then
        # undo all changes on git
        git reset --hard && git clean -fd
    else
        release "$_version"
    fi
}

while (($#)); do
    opt="$1"
    case "$opt" in
        -u | --user)
            USER_NAME="$opt"
            shift
            shift
            ;;
        -e | --email)
            USER_EMAIL="$opt"
            shift
            shift
            ;;
        -t | --type)
            TYPE="$opt"
            shift
            shift
            ;;
        -m | --msg | --message)
            MESSAGE="$opt"
            shift
            shift
            ;;
        -b | --branch)
            BRANCH="$opt"
            shift
            shift
            ;;
        -p | --preview)
            TYPE="preview"
            shift
            ;;
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

main
