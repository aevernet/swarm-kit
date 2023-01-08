<h1 align="center">
<img src="https://raw.githubusercontent.com/aevernet/.github/master/images/banner/Aever-SW-D-800.png" alt="Aevernet">

Step 1 - Setup WSL2 (Ubuntu)

Manually

</h1>

> This is the long way of doing things and is recommended only if:<br />
>   1. You know what you're doing
>   2. You want to make a few changes along the way
>
> You can find the quick and easy version [**here**](wsl-init-auto.md)

## Prerequisites

It is assumed that you're starting with a clean install of Ubuntu 20.04+ from the Window's Store.

## Install "Bash Bits"

`Bash Bits` is my modular library for Bash which has been written with WSL2 in mind.  It's included as a submodule of this repository, so you don't need to look very hard for it.  Installation is fully-automated, although you can make some configuration changes if you wish.  See the [**Bash Bits**](https://github.com/Ragdata/bash-bits) project documentation for details.

Installing with NPM:

```shell
npm run bb-install
```

Installing with Bash:

```shell
bash submodules/bash-bits/src/bin/install.sh
```

And in one fell swoop, you've gained a bunch of useful aliases, functions, and dotfiles that you will one day wonder how you ever lived without.

## Initial Environment Setup

The very first thing you'll need to do is give your root user a password:

```shell
sudo passwd root
```

Then, switch to root privileges:

```shell
su
```

## Enable Systemd on WSL2

To set this up, you need to be running WSL version `0.67.6` or higher.  You can check your version by running this command under PowerShell or a Command Prompt:

```powershell
wsl --version
```

If that command fails, then you're running the in-Windows version of WSL and need to [upgrade to the Store version][upgrade-wsl].

### Set the `systemd` flag in your WSL distro settings

You will need to edit your [wsl.conf][wsl-conf] file to ensure systemd starts on boot.

Add these lines to the `/etc/wsl.conf` file of each distro where you want to enable systemd.

```shell
echo "" >> /etc/wsl.conf
echo "[boot]" >>/etc/wsl.conf
echo "systemd=true" >> /etc/wsl.conf
```

And it's really just that easy!

Reboot WSL, and when it comes back up you'll be running under `systemd`!

You can check by running this command in your terminal:

```shell
systemctl list-unit-files --type=service
```

<br />

> 💡 TIP: This simple one-liner will return either **systemd** or **init** to let you know which service manager you're using
>
> ```shell
> ps --no-headers -o comm 1
> ```
>
> In this form it's really easy to use in scripts as well, like so:
>
> ```shell
> [[ "$(ps --no-headers -o comm 1)" == "init" ]] && echo "Service Manager is Initd"
> ```


## Add Required APT Repositories

First, make a backup of the existing sources list:

```shell
cp /etc/apt/sources.list /etc/apt/sources.list~
```

Then, execute the following commands to add the required repositories:

```shell
add-apt-repository -y universe
add-apt-repository -y ppa:deadsnakes/ppa
add-apt-repository -y ppa:ondrej/php
```

## Update & Upgrade

Now, update the apt database and upgrade everything to the lastest version:

```shell
apt update && apt upgrade -y
```

## Harden System



## Install Basic Services





[upgrade-wsl]: https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/#how-to-install-and-use-wsl-in-the-microsoft-store
