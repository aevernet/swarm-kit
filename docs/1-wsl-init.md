<h1 align="center">
<img src="https://raw.githubusercontent.com/aevernet/.github/master/images/banner/Aever-SW-D-800.png" alt="Aevernet">

Setup WSL2 Instance (Ubuntu)

Manually

</h1>

> This is the long way of doing things and is recommended only if:<br />
>   1. You know what you're doing
>   2. You want to make a few changes along the way
>
> You can find the quick and easy version [**here**](wsl-init-auto.md)

## Prerequisites

It is assumed that you're starting with a clean install of Ubuntu 20.04+ from the Window's Store.

## Introduction

I've never been an Apple or Mac person.  From the very beginning, I've been a hardcore PC Junkie running the latest version of Windows and I've made absolutely no apologies whatsoever for doing so.  Oh sure, I went through my wanker phase when I hit university after the Army (mid-1990's) and installed Linux a couple of times and actually stuck with it for a few hours until I realised I couldn't get my favourite games to run - but never fear, I was just as much a hypocrite as the rest of them while slagging off Bill Gates and his corporate monolith which stood poised to dominate computing to its utter ruin ... or so we feared back then.

If you haven't been an avid Windows user over the past few years, you _may_ have missed a trend which, I must admit, initially stunned me when I first realized the extent of it all.  Microsoft - rather than betraying us all and locking the world into their own particularly sadistic brand of proprietary technologies forever, have for several years now been one of the most benevolent champions of open-source technology and have put their money where their mouth is in a big way.

Not only do they own [GitHub](https://github.com) (the world's largest repository of open-source software) and host repositories for the greatest and lowliest of software developers alike from all over the globe - and they do so for the vast majority of us absolutely free of charge.  You can see their true colors expressed in the WSL (Windows Subsystem for Linux) and the WSA (Windows Subsystem for Android) which is due for release to the wider market early in 2023.  They're literally banking the foundation of their core product offering - the Windows Operating System - on a proprietary version of Linux they call [CBL-Mariner](https://www.xda-developers.com/boot-cbl-mariner-microsoft-linux-distribution/).

I can tell you that from the perspective of a professional software engineer who spent the majority of their career writing software intended to be run on some form of device running some incarnation of Linux or another on a PC running Windows, the advent of the WSL was the thing I had most longed for my entire career without ever realising it.

My Windows PC is a tool that I finally feel is starting to exceed my expectations rather than constrain them, and the WSL is a big part of the reason for that.

[`^ Top`](#prerequisites)


## Install NVM



[`^ Top`](#prerequisites)


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

[`^ Top`](#prerequisites)

## Initial Environment Setup

The very first thing you'll need to do is give your root user a password:

```shell
sudo passwd root
```

Then, switch to root privileges:

```shell
su
```

[`^ Top`](#prerequisites)

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

[`^ Top`](#prerequisites)

## Fortify APT

Before we get too far into it, we're going to make sure the `apt` package has everything it needs:

```shell
apt install -y apt-transport-https apt-listchanges
```

[`^ Top`](#prerequisites)

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

And if you plan on setting your WSL2 installation up as your Landscape Server (you should), you'll want to add the following repository to the list above:

```shell
add-apt-repository -y ppa:landscape/19.10
```

[`^ Top`](#prerequisites)

## Update & Upgrade

Now, update the apt database and upgrade everything to the lastest version and take out the trash:

```shell
apt update && apt upgrade -y && apt autoremove && apt autoclean
```

[`^ Top`](#prerequisites)

## Harden System

"Hardening" a system is just a quicker way to say that you're going to beef up security a little.  Now, what I've given you here should by NO MEANS be considered the be-all-and-end-all of your system's security.  Having said that, the tools available for free these days are _incredibly_ capable, and in order to be hacked you really need to be doing something monumentally stupid ... like planning on connecting your home computer directly to the Internet like we'll be doing just a little later on ... relax, I've got a secret up my sleeve that makes it all SUPER SECURE and EASY ... (and absolves yours truly of any and all responsibility for YOUR stupidity) 😁

### 1. Create Administrative User

Now, because we intend to expose our network to _incoming_ traffic from the Internet, keeping a root user around on the most important machine in our network is just plain stupid.  The first step to getting rid of root is to create an 'Administrative User' who will be empowered to do everything that needs doing, but without all that extra (and, let's face it, wasted) power to do things you haven't even tried to understand yet.  It's like operating with surgical precision rather than trying to do _anything_ wearing welding mits and a blindfold.

```shell
adduser <username>
```

Add your new user to your sudoer's group:

```shell
usermod -aG sudo <username>
```

And because you've been clever and set your own user account up with all the ssh keys and everything else you need to fly this machine comfortably, you'll want to sync your new Admin user account with it:

```shell
rsync --archive --chown=<username>:<username> ~/.ssh /home/<username>
```

[`^ Top`](#prerequisites)

### 2. Configure A Firewall

Now, because we're using Ubuntu it's likely that we've already got UFW installed.  Check it like this:

```shell
ufw status
```

If you got the message `Status: inactive` don't panic - we'll change that shortly.

First, let's start throwing our weight around a little and denying ALL inbound connections by default:

```shell
ufw default allow outgoing
ufw default deny incoming
```

We're also going to need an SSH pass-through - so you if you intend to change your SSH port number (and you should), I guess you should pick your port number sooner rather than later:

```shell
ufw allow <number>
```

And NOW we can enable our Firewall (don't panic - we'll do more with it later):

```shell
ufw enable
```

You can even check the status again if you like:

```shell
ufw status
```

> **NOTE**
>
> You should consider any firewall you set up under WSL to be a backup to your **Windows Defender Firewall** ONLY.  To properly configure a firewall for WSL2, start by making sure Windows Defender is at least turned on, and we can deal with the rest later on ...

### 3. Prevent root user from logging in via ssh

Now, you could simply open a text editor and edit the ssh config file directly - but then you wouldn't be allowing me to kill 2 birds with one stone by writing 99% of the code for the setup script in this tutorial first ... and that would be selfish, wouldn't it?  So, we're going to do it the stylish way ... with **sed**:

```shell
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
```

### 3a. Secure SSH

SSH is going to be our best friend from now on, so it's worth spending a little extra time to make sure we've got it set up _properly_.  Let's get started, shall we?

#### Change Default SSH Port

It's the simplest changes sometimes which can have the greatest impact.  By changing our default SSH port from 22, we're immediately reducing the number of stupid 'noob' level mistakes that those evil "black-hat" hackers are _counting_ on us to make.  So, pick a number between 100 and 64000:

```shell
sed -i 's/#Port 22/Port <port>/' /etc/ssh/sshd_config
```

> **NOTE**
>
> You're going to need to update your Windows Defender Firewall (_at least_) with your new SSH port number too.

> **'NUDDA NOTE**
>
> The command you're going to need to use from now on to connect to your server from the command line will be:
>
> ```shell
> ssh user@xxx.xxx.xxx.xxx -p <port>
> ```

#### Enable Protocol 2

By default, SSH uses Protocol 1 - whereas Protocol 2 is newer (2006), more secure, more robust, and is definitely what the cool kids are playing with these days:

````shell
echo "Protocol 2" >> /etc/ssh/sshd_config
````

#### Configure public / private key authentication

Using public / private key pairs for authentication is infinitely more secure than using a password, so you really should be doing this everywhere you are able to do so.  Systems protected with passwords are MUCH more vulnerable to brute-force attacks than key-pair authenticated servers:

```shell
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
```

#### Restrict Logins to selected IP's

If you don't have the information on hand right now to complete this step, that's fine - just skip it for now and move on.  However, you really should get back here as soon as you are able.  The default config for your SSH server allows inbound connections from any IP address - which is pretty foolish when you think about it, isn't it?  Make a list of the IP addresses you want to be able to connect from (don't forget your phone) and modify your firewall to allow these and block all other attempts to connect to your SSH port:

```shell

```

#### Restrict Access to Specified Users

Why stop at restricting IP's when we can restrict exactly which users are allowed to connect to our SSH server:

```shell
echo "AllowUsers <username>" >> /etc/ssh/sshd_config
```

#### Setup an Idle Timeout

To make sure we don't leave any zombie connections hanging around just waiting to be exploited by anyone who cares to look for them (and we do this a LOT), we can set a time limit that any connected terminal is allowed to remain idle before the server automatically terminates the session:

```shell
sed -i 's/#TCPKeepAlive.*/TCPKeepAlive yes/' /etc/ssh/sshd_config
sed -i 's/#ClientAliveInterval.*/ClientAliveInterval 60/' /etc/ssh/sshd_config
sed -i 's/#ClientAliveCountMax.*/ClientAliveCountMax 3/' /etc/ssh/sshd_config
```

#### Limit Failed Password Attempts

Since a brute force attack literally hits a single server over and over again trying different passwords in the hope of getting lucky, all we have to do to protect ourselves from them is limit the number of times a single session can fail a password authorisation check.  FYI - Fail2Ban, which we'll be setting up in just a short while - does this for us automatically ... but don't think that means you can get lazy all of a sudden:

```shell
sed -i 's/#MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config
```

#### Disable X11 Forwarding

You may want to spare just a moment to think about whether or not you are going to need to run any graphical applications via SSH before you dive into this one ... but you can always open it up again if you change your mind later:

```shell
sed -i 's/X11Forwarding.*/#X11Forwarding no/' /etc/ssh/sshd_config
```

[`^ Top`](#prerequisites)

#### Enable 2FA (yes - on the command line)

You should make a habit of this as it really does bring the security of your internet-exposed servers to a whole new level and only costs a _minuscule_ amount of time:

(We'll be installing Google Authenticator)

```shell
sudo apt install -y libpam-google-authenticator
```

Add a line to `/etc/pam.d/sshd`:

```shell
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
```

And change this to 'yes':

```shell
sed -i 's/ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
```

And configure Google Authenticator for the user of your choice:

```shell
google-authenticator
```

Time-based tokens - y

After answering yes to the first question you'll be presented with a QR code and backup codes.  Open Google Authenticator on your Android/iPhone and scan the QR code ... also, stash those emergency codes somewhere SAFE (**AND NO - DO NOT LOSE THEM!!**) 😡 (<< so you know I'm deadly serious and NOT joking ... stop laughing ...)

update.google-authenticator - y

Disallow multiple uses - y

Permit shew of up to 4 minutes - n

Enable rate limiting - y

Then YES - NO - YES to the huge blobs of text you won't bother to read ...

Now, restart the SSH service:

```shell
sudo service ssh restart
```

Which is going to trash any SSH sessions you were logged in to, so cross your fingers that you haven't stuffed up and are going to be able to get back in just fine ...

[`^ Top`](#prerequisites)

### 4. Secure `/tmp` and `/var/tmp`

Temporary storage is often used by hackers to store malicious executables.

So, let's start by creating a 1GB filesystem file for the `/tmp` partition:

```shell
fallocate -l 1G /tmpdisk
mkfs.ext4 /tmpdisk
chmod 0600 /tmpdisk
```

Next, mount the new partition and set the correct permissions:

```shell
mount -o loop,noexec,nosuid,rw /tmpdisk /tmp
chmod 1777 /tmp
```

Make it official with `fstab`:

```shell
echo ": /tmpdisk    /tmp    ext4    loop,nosuid,noexec,rw   0 0" >> /etc/fstab
```

And finish it off by securing `/var/tmp`:

```shell
mv /var/tmp /var/tmpold
ln -s /tmp /var/tmp
cp -prf /var/tmpold/* /tmp/
rm -rf /var/tmpold/
```

[`^ Top`](#prerequisites)

### 5. Set Security Limits

A simple way to protect your system from fork bomb attacks is by setting a process limit for your users.

Limits can be configured in the `/etc/security/limits.conf` file

```shell
# this first line removes the last line from the specified file WITHOUT having to read the entire file
tail -n 1 /etc/security/limits.conf | wc -c | xargs -I {} truncate /etc/security/limits.conf
echo "${REGISTRY[SYSUSER]}  hard    nproc   100" >> /etc/security/limits.conf
echo "${REGISTRY[MYUSER]}  hard    nproc   100" >> /etc/security/limits.conf
```

[`^ Top`](#prerequisites)

### 6. Disable IP Spoofing

IP Spoofing is what it's called when a hacker sends Internet Protocol (IP) packets with a forged source IP address, with the purpose of concealing their identity or to impersonate another, perhaps trusted, system:

```shell
sed -i 's/order hosts,bind/order bind,hosts/' /etc/host.conf
echo "nospoof on" >> /etc/host.conf
```

[`^ Top`](#prerequisites)

### 7. Install Fail2Ban

`Fail2Ban` is an intrusion detection system which monitors system logs looking for unusual behaviour and failed login attempts.  If it detects multiple failed logins it will blacklist the IP address from which those requests originate.

To install `Fail2Ban`:

```shell
apt install -y fail2ban
```

Check service status:

```shell
service fail2ban status
```

`Fail2Ban` uses 'jail' files to store configuration.  Global config is in `/etc/fail2ban/jail.conf`.

We'll create a local config file at `/etc/fail2ban/jail.local`:

```shell
cat << EOF > /etc/fail2ban/jail.local
[DEFAULT]
bantime = 8h
ignoreip = 127.0.0.1/8 xxx.xxx.xxx.xxx
ignoreself = true

[sshd]
enabled = true
port = 2022
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF
```

If you have a local static IP that you use to connect to your system, insert it in place of the `xxx.xxx.xxx.xxx` - otherwise leave it blank.

Restart `Fail2Ban`:

```shell
service fail2ban restart
```

To list banned IP's:

```shell
sudo iptables -L f2b-sshd --line-numbers
```

To remove a ban:

```shell
sudo iptables -D fail2ban-ssh <chain number>
```

[`^ Top`](#prerequisites)

### 8. Install AntiVirus

Whether or not you need to install antivirus on Linux is a hotly debated topic in the Linux community.

You should assess your level of risk, and your system's workload to help you decide if you need to install AV.

Here we're installing ClamAV which is a free, open-source AV for Linux:

```shell
apt install -y clamav clamav-daemon
```

To update it, we first need to stop the service:

```shell
systemctl stop clamav-freshclam
```

Update like so:

```shell
freshclam
```

And then restart and enable the service once the initial update is complete:

```shell
systemctl start clamav-freshclam
systemctl enable clamav-freshclam
```

So we don't have to think about it ever again, we'll set up a cron job to take care of daily updates:

```shell
cat << EOF > /etc/cron.daily/freshclam
#!/usr/bin/env bash
/usr/bin/freshclam --quiet
exit 0
EOF

chmod +x /etc/cron.daily/freshclam
```

[`^ Top`](#prerequisites)

### 9. Install Anti-RootKit

One more front-line defence package you should consider is `rkhunter` which looks for rootkits.

To install:

```shell
apt install rkhunter
```

A little surgical strike to take care of configuration:

```shell
sed -i 's/UPDATE_MIRRORS.*/UPDATE_MIRRORS=1/' /etc/rkhunter.conf
sed -i 's/MIRRORS_MODE.*/MIRRORS_MODE=0/' /etc/rkhunter.conf
sed -i 's/WEB_CMD.*/WEB_CMD=""/' /etc/rkhunter.conf

sed -i 's/CRON_DAILY_RUN.*/CRON_DAILY_RUN="true"/' /etc/default/rkhunter
sed -i 's/CRON_DB_UPDATE.*/CRON_DB_UPDATE="true"/' /etc/default/rkhunter
sed -i 's/APT_AUTOGEN.*/APT_AUTOGEN="true"/' /etc/default/rkhunter

rkhunter --update
rkhunter --propupd
```

To initiate a scan:

```shell
rkhunter -C
```

[`^ Top`](#prerequisites)

### [optional] Disable root account completely

> There could be any number of reasons that you WOULDN'T complete this step, so I'm not going to bother to list any.  If you can't think of one right NOW though, you really need to do this ...

Rendering your root account completely non-functional is very simple and just as easy to reverse if you need to:

```shell
sudo passwd -l root
```

And, as promised, if you ever need to re-enable it:

```shell
sudo passwd root
```

[`^ Top`](#prerequisites)

### Configure Swapspace



[`^ Top`](#note)

[**<< Chapter 1 - Setup Cluster**](1-Cluster.md)  🔸  [**INDEX**](0-Index.md)  🔸  [**Chapter 1 - Basic Services >>**](1-basic-services.md)

[upgrade-wsl]: https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/#how-to-install-and-use-wsl-in-the-microsoft-store
