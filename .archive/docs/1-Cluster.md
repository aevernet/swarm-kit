<h1 align="center">
<img src="https://raw.githubusercontent.com/Ragdata/Ragdata/master/images/logo/banner/SK2-800x400.png" alt="Aevernet">

Chapter 1

Setting Up Your Cluster
</h1>

## 📖 Chapter Contents

- **Chapter 1 - Setting Up Your Cluster**
  - **Setup WSL2 (Ubuntu) [Auto](1-vm-init-auto.md) / [Manual](1-wsl-init.md)**
  - **Setup Virtual Machines [Auto](1-vm-init-auto.md) / [Manual](1-vm-init.md)**
  - [**Basic Services**](1-basic-services.md)
  - [**Primary Services**](1-primary-services.md)
    - [**Ceph**](pkgs/ceph.md)
    - [**Docker**](pkgs/docker.md)
    - [**Landscape**](pkgs/landscape.md)

## 📈 THE PLAN

The

### 🥇 Our Goal

## 🔑 Prepare Public / Private Key Pairs

The very first thing we need to do is create a few Public/Private Key Pairs to use as authentication keys both on the servers you're about to create, and one special key that we're going to create for your GitHub account.

Authenticating this way is infinitely more secure than using passwords, and far more convenient as well.  If this is your first experience doing things this way, your world is about to change for the better!

We'll need a set of keys for each of the following:

- GitHub Account
    - if you didn't have one before, you're getting one now ...
- SSH Access to WSL2
- SSH Access for each of your Virtual Machine Instances (3)

... which makes a total of 5 keys by my count - so repeat the following steps 5 times giving each key pair a unique name and set them aside until later:

Generate a key pair:

```shell
ssh-keygen -b 4096
```

After entering the command, you should see the following:

```shell
Output
Generating public/private rsa key pair.
Enter file in which to save the key (/your_home/.ssh/id_rsa):
```

Remember that you're going to need to give each pair a new name.  I'd suggest the following so that you know straight away what each is used for:

- ~/.ssh/id_git
- ~/.ssh/id_wsl
- ~/.ssh/id_node1
- ~/.ssh/id_node2
- ~/.ssh/id_node3

Next bit of output you'll get is this:

```shell
Output
Enter passphrase (empty for no passphrase):
```

Now I'm obliged to tell you that you're an idiot if you don't give each one a unique and meaty passphrase.  Personally, I don't do that with keys that I intend to use for authenticating with machines on my internal network because passwords are a pain in the ass and as long as you are confident you can keep these keys safe, the passphrase is a moot point.

What about GitHub I hear you say?  Hey - I NEVER ONCE claimed I wasn't an idiot ...

If you want a second opinion, [check out what GitHub has to say](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) about passphrases on your SSH keys.  I'd listen to them if I were you ... but I'm not ... what are you looking at? 😠

Whether you choose to use a passphrase or not, you should now see output like the following:

```shell
Output
Your identification has been saved in /your_home/.ssh/id_rsa
Your public key has been saved in /your_home/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:/hk7MJ5n5aiqdfTVUZr+2Qt+qCiS7BIm5Iv0dxrc3ks user@host
The key's randomart image is:
+---[RSA 3072]----+
|                .|
|               + |
|              +  |
| .           o . |
|o       S   . o  |
| + o. .oo. ..  .o|
|o = oooooEo+ ...o|
|.. o *o+=.*+o....|
|    =+=ooB=o.... |
+----[SHA256]-----+
```

Now, scroll back up and repeat that process until you have the full set of keys listed.

I'll expand upon this a little more later, but in order to use these keys you'll need to add them to your `ssh-agent`, and you do that like this:

Step 1 - Make sure the agent is running.  Check out these instructions about auto-launching the ssh-agent, or you can start it manually like they did in the olden days:

```shell
eval "$(ssh-agent -s)"
```

Step 2 - Add your SSH PRIVATE KEY to the ssh-agent (the one WITHOUT the .pub extension):

```shell
ssh-add ~/.ssh/<key_name>
```

Step 3 - Add the SSH key you called `id_git` to your GitHub account by following [these instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

And that's it!  Setting your other keys up to use for SSH access to each node of your cluster is done very differently - but you still need to add each of them to your `ssh-agent`, and I'll show you exactly how to do that a bit later on.


[**<< Index & Introduction**](0-Index.md)  🔸  [**INDEX**](0-Index.md)  🔸  [**Chapter 1 - Setup WSL2 (Manual) >>**](1-wsl-init.md)
