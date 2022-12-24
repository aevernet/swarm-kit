#!/usr/bin/env bash

YEAR="$(date '+%Y')"

writeREADME() {
    cat << EOF > "$baseDir"/README.md
<p align="center">
    <h3>"$REPO_DESC<br>v0.1.0</h3>
    <br><br>
    <h4><a href="issues">ISSUES</a> &nbsp;||&nbsp; <a href=".github/CODE_OF_CONDUCT.md">CODE OF CONDUCT</a> &nbsp;||&nbsp; <a href=".github/CONTRIBUTING.md">CONTRIBUTING</a></h4>
</p>

## 📖 Table of Contents

- [Overview](#-overview)
- [Installation](#-installation)
- [What's Included](#-whats-included)
- [Screenshots](#-screenshots)
- [Author / Maintainer](#-author--maintainer)
- [Contributors](#-contributors)
- [Supporters](#-supporters)
- [Copyright & Attributions](#-copyright--attributions)
- [License](#-license)
- [Resources](#-resources)

## 👀 Overview

<!-- Why did you create this project?  Explain your motivations, its purpose, your objectives, etc -->



## 📂 Installation

<!-- Give instructions on how to install your project -->



### [🔝](#-table-of-contents)

## ❓ What's Included?

<!-- Describe the different parts of your project - especially if they provide value of their own accord -->



### [🔝](#-table-of-contents)

## 📸 Screenshots

<!-- Show some screenshots of your UI or other interesting aspects of your project -->



### [🔝](#-table-of-contents)

## 🚧 Author / Maintainer

<!-- List your details -->



### [🔝](#-table-of-contents)

## 💎 Contributors

<!-- List your contributors -->



### [🔝](#-table-of-contents)

## 🏆 Supporters

<!-- List your supporters -->



### [🔝](#-table-of-contents)

## ©️ Copyright & Attributions

<!-- Display your copyright alongside the copyrights of as many of your dependencies as you can -->


> "We see much further, and reach much higher,<br>
> only because we stand upon the shoulders of giants"

### [🔝](#-table-of-contents)

## 📄 License

<!-- Include details of your chosen license -->



### [🔝](#-table-of-contents)

## 📖 Resources

<!-- Include any additional resources that might be useful to someone who is learning about your project -->



### [🔝](#-table-of-contents)

EOF
}

writeLICENSE() {
    cat << EOF > "$baseDir"/LICENSE
"$LICENSE" License

Copyright © "$YEAR" "$USER_NAME"

<!-- You need to include the text of your license here -->
EOF
}

writeCOPYRIGHT() {
    cat << EOF > "$baseDir"/COPYRIGHT
"$REPO_DESC" v0.1.0

Copyright © "$YEAR" "$USER_NAME"

====================================================================
ATTRIBUTIONS
====================================================================

This project incorporates ideas and / or code crafted by the following
talented individuals:



====================================================================
         "We see much further, and reach much higher,
      only because we stand upon the shoulders of giants"
====================================================================
EOF
}

writePACKAGE() {
    cat << EOF > "$baseDir"/package.json
{
    \"name\": \""$REPO_NAME"\",
    \"description\": \""$REPO_DESC"\",
    \"version\": \"0.1.0\",
    \"repository\": {
        \"type\": \""$REPO_TYPE"\",
        \"url\": \""$REPO_URL"\"
    },
    \"author\": {
        \"name\": \""$USER_NAME"\",
        \"email\": \""$USER_EMAIL"\",
        \"url\": \""$USER_URL"\"
    },
    \"license\": \""$LICENSE"\",
    \"bugs\": {
        \"url\": \""$ISSUES"\"
    },
    \"homepage\": \""$HOMEPAGE"\"
}

EOF
}

writeCONFIG() {
    cat << EOF > "$baseDir"/.github/ISSUE_TEMPLATE/config.yml
blank_issues_enabled: true
contact_links:
EOF
}

writeSUPPORT() {
    cat << EOF > "$baseDir"/.github/SUPPORT.md
# Support Links

Looking for support for this project?  Here's a few places you might like to try:

- Click the `Wiki` tab at the top of the page (if it exists)
- Click the `Issues` tab at the top of the page (if it exists)
- Click the `Discussions` tab at the top of the page (if it exists)
EOF
}
