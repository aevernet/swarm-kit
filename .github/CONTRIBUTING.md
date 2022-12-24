# Contributing to this project

Firstly, I'd like to thank you personally for taking the time to help improve this project, I truly appreciate it! 💓 Here are a few guidelines to help ensure that all contributions are heading in the same direction:

You can contribute by:

- creating pull requests
- creating or responding to issues
- supporting the development and maintenance of my projects by [sponsoring me on GitHub][sponsorship] by taking up a monthly subscription or by making one-off donations.
- giving the project a star ⭐
- supporting me through one of my social channels (see [SUPPORT][support])

## Basic Process

Generally, the way to create a **Pull Request** is to:

1. Fork this project and clone it locally
2. Create a new branch from the master branch and give it a descriptive name followed by the issue number, if applicable (format: `feature/<new feature> [#issue]` or `fix:<bug> [#issue]`)
3. AFTER completing development AND TESTING, submit a new _Pull Request_
   1. (note that your commit message MUST follow the [Conventional Commits Guidelines][conventional-commits], otherwise it will fail the PR check)

## Javascript Style Guide

If your contribution includes javascript, please read the following:

### Inline Scripts

If you need to add comments to the inline Javascript code (code between the `<script>   </script>` tags), please be sure to use `/*  */` instead of double slashes.

## Verify Your Commit Messages!

If you want to make sure your commit messages will pass the CI check, implement the following:

### Valid Commit Types

- build
- chore
- ci
- docs
- feat
- fix
- perf
- refactor
- revert
- style
- test

### Valid Commit Message Structure

```console
<type>(optional scope): <subject>

<optional body>

<optional footer>
```

### RULES

- Type MUST be one of those in the list above
- Type MUST be all lowercase
- Type CANNOT be empty


- Subject MUST start with a lowercase letter
- Subject CANNOT be empty
- Subject CANNOT end in a period


- Max length of `<type>(scope): <subject>` is 100 chars


- Body MUST be preceded by a blank line
- Max length of body is 100 chars PER LINE


- Footer MUST be preceded by a blank line
- Max length of footer is 100 chars PER LINE

### Examples

#### Commit message with description and BREAKING CHANGE footer:
```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for
extending other config files
```
#### Commit message with `!` to draw attention to breaking change:
```
feat!: send an email to the customer when a product is shipped
```
#### Commit message with scope and `!` to draw attention to breaking change:
```
feat(api)!: send an email to the customer when a product is shipped
```
#### Commit message with both `!` and BREAKING CHANGE footer
```
chore!: drop support for Node 6

BREAKING CHANGE: use Javascript features not available in Node 6
```
#### Commit message with no body
```
docs: correct spelling of CHANGELOG
```
#### Commit message with scope
```
feat(lang): add Polish language
```
#### Commit message with multi-paragraph body and multiple footers
```
fix: prevent racing of requests

Introduce a request id and a reference to latest request.
Dismiss incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue
but are obsolete now.

Reviewed-by: Z
Refs: #123
```

### Remember Always:

> _We see much further, and reach much higher, only because we stand upon the shoulders of giants_


:tada: **THANK YOU** :tada:

[sponsorship]: https://github.com/sponsors/Ragdata
[support]: SUPPORT.md
