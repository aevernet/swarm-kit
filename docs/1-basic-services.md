<h1 align="center">
<img src="https://raw.githubusercontent.com/aevernet/.github/master/images/banner/Aever-SW-D-800.png" alt="Aevernet">

Install & Configure Basic Services

</h1>

> #### NOTE
>
> Since we're starting with a fresh Ubuntu installation, many of the packages mentioned below may already be installed.  There is no cause for panic, however, since apt will essentially skip over them if they're already installed.
>
> It might be worth mentioning here also that the way these basic services are being installed here directly reflects what you will find if you use their installers in the `$ELEM` directory.

### Git

Substitute the username and email address you want to associate with your git commits where appropriate:

```shell
apt install -y git

git config --global user.name "username"
git config --global user.email "email"
```

[`^ Top`](#note)

### Timezone

```shell
timedatectl set-timezone "<timezone>"
```

[`^ Top`](#note)

### Locale



[`^ Top`](#note)

### My Base Toolset

This is a set of tools that I find useful to have lying around more often than not - feel free to change this to suit yourself:

```shell
apt install -y gnupg2 snapd bash-completion daemon libsqlite3-dev sqlite3 mcrypt screen ca-certificates
apt install -y software-properties-common id-utils uuid arj bzip2 nomarch lzop unzip zip cabextract libyaml-dev libxml2-dev libxslt1-dev
apt install -y debconf-utils binutils zlib1g-dev build-essential libssl-dev libreadline-dev
apt install -y libcurl4-openssl-dev libffi-dev libgdbm-dev libncurses5-dev automake libtool bison ffmpeg certbot python3-certbot-nginx
apt install -y htop telegram-cli lvm2 moreutils
```

[`^ Top`](#note)

### [Cockpit](https://cockpit-project.org/)

This is one of those you may choose to skip if you don't have a need for it.

Cockpit is a basic GUI server control panel accessed via a browser:

```shell
apt install -y cockpit

service cockpit start
service cockpit status
```

[`^ Top`](#note)

### [Unattended Upgrades](https://www.how2shout.com/linux/how-to-configure-unattended-upgrades-in-ubuntu-20-04/)

Unattended Upgrades will ensure all of the packages on your instance will be kept up-to-date automatically:

```shell
apt install -y unattended-upgrades
```

Check Service Status

```shell
systemctl status unattended-upgrades --no-pager -l
```

Configure the service:

```shell
cat << EOL > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOL
```

[`^ Top`](#note)

### Network



[`^ Top`](#note)

### Shellcheck



[`^ Top`](#note)

### Python



[`^ Top`](#note)

### Go



[`^ Top`](#note)

### PERL



[`^ Top`](#note)

### PHP



[`^ Top`](#note)

### Composer



[`^ Top`](#note)

### UWSGI



[`^ Top`](#note)

### CRON Updates



[`^ Top`](#note)

### Logwatch



[`^ Top`](#note)

### MSMTP



[`^ Top`](#note)

### Mailutils



[`^ Top`](#note)

### Multipath



[`^ Top`](#note)

[**<< Chapter 1 - Cluster Setup**](1-Cluster.md)  🔸  [**INDEX**](0-Index.md)  🔸  [**Chapter 1 - Primary Services >>**](1-primary-services.md)
