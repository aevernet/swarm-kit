<h1 align="center">
<img src="https://raw.githubusercontent.com/aevernet/.github/master/images/banner/Aever-SW-D-800.png" alt="Aevernet">

Setup WSL (Ubuntu)

Manual

</h1>

## Prerequisites

It is assumed that you're starting with a clean install of Ubuntu 20.04+ from the Window's Store.

## Initial Setup

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

Reboot WSL, and when it comes back up you'll be running under `systemd`!  You can check by running this command in your terminal:

```shell
systemctl list-unit-files --type=service
```
