<h1 align="center">
<img src="https://raw.githubusercontent.com/aevernet/.github/master/images/banner/Aever-SW-D-800.png" alt="Aevernet">

Swarm-Kit Documentation

v0.1.0

</h1>

## 👀 Overview

This collection of how-to documents and scripts will walk you through the process of setting up your very own, self-hosted, high-availability server infrastructure that - whether you do it as a hobby or in order to support your online business - will potentially save you hundreds if not _thousands_ of dollars each month in service subscriptions.

This project will show you:

- How to setup and maintain your own local 'cluster'
- How to securely access your home-based services via the internet
- How to install dozens of top-rated open-source applications
- How to containerise your own applications
- And much more!

## 📖 Table of Contents

- [**Chapter 1 - Setting Up Your Cluster**](1-Cluster.md)
  - [Setup WSL (Ubuntu)](wsl-init.md)
  - [Setup Virtual Machines (Ubuntu)](vm-init.md)

## 📘 Introduction

Initially you'll see that this guide is written from the perspective of a Windows (10 or 11) user, but the majority of the action happens in Linux which can be run by literally _anyone_ without great difficulty or expense.  If you're not using Windows, you can probably skip the whole first chapter and jump right into the second - and you'll notice that I don't spend a whole lot of time at all discussing how to actually get to the point where you're installing Ubuntu on your virtual machines.  This is because there are a whole bunch of different ways to achieve this step, and how you get to this point is largely up to personal preference.  `Swarm-Kit` is really about what happens once you've got your virtualisation platform sorted out.

### How will this benefit you?

Even though we've had the benefit of container technologies for a few years now, I feel their full potential is not yet being exploited.  I hope that by making this guide available, I can help more people realise the fantastic resource that container technologies offer, and make them a little less scary and a little more available for those of you who don't have a lot of experience working with them.  The truth is that _every_ business can benefit from containerisation, and the impact they will have on your bottom line is not to be underestimated.

### Who am I?

I'm Darren - and I use the nickname "Ragdata" online.

At university I studied Machine Learning, and for the past 25 years I've worked as a software engineer exclusively using online technologies.  My first job out of university was helping to build the world's first content management system with integrated e-commerce capabilities at a time when even the banks in Australia weren't able to provide online payment services to local businesses.  I produced Australia's first-ever grocery shopping website in conjunction with GDM Wholesalers at the Rocklea Markets in Brisbane before Mark Zuckerberg had launched his "face-thing" site and while the Googlers were still working out of their garage.  Here in the background I helped to define the way that the world does business today, and I want to help more of you get your heads around the way we'll be powering the way we do business tomorrow.

### What do I want from you?

I want your [support][support] - either financially, as a customer, or as a member of one of the communities I'm building.

#### 💬 Get in Touch

You can get in touch with me through any of the following social media channels:

- [GitHub][github]
- [Facebook][facebook]
- [Twitter][twitter]
- [Patreon][patreon]
- [Substack][substack]

#### ❤️ Sponsor Me

The best way to sponsor my work is to become a [GitHub Sponsor][support] or one of my [Patrons][patreon].  In return you'll receive:

- Warm Fuzzies
- Recognition on my GitHub Profile & Website
- An Invitation to my [Private Discord Server][discord]
- Elevated Privileges on my [Private Discord Server][discord]
- Additional loot based on your support tier

I'll receive:

- Warm Fuzzies
- Help paying for servers I rent to host content
- Help paying for services I use to produce content

#### 🤝 Work with Me

If you feel you could use my professional services, please [get in touch][email] and let me know how I can help

#### ☕ Buy me a Coffee

If you aren't in a position to sponsor my work on a monthly basis, why not [buy me a coffee][one-off] with a one-off donation instead?

## 🔗 Resources

- [konstruktoid/hardening](https://github.com/konstruktoid/hardening)
- [Ubuntu Secure Server](https://ostechnix.com/ubuntu-server-secure-script-secure-harden-ubuntu/)
- [badsyntax/docker-box](https://github.com/badsyntax/docker-box)
- [Script to create a docker swarm mode cluster](https://charmingwebdesign.com/script-to-create-a-docker-swarm-mode-cluster/)
- [Bash-it](https://github.com/Bash-it/bash-it/tree/master/.github)


[support]: https://github.com/sponsors/Ragdata
[facebook]: https://facebook.com/RedeyedSoftware
[twitter]: https://twitter.com/RagdataAU
[patreon]: https://patreon.com/redeyed
[substack]: https://ragdata.substack.com
[github]: https://github.com/Ragdata
[discord]: https://discord.gg/cESSqE29k8
[one-off]: https://github.com/sponsors/Ragdata?frequency=one-time&sponsor=Ragdata
[email]: mailto:ragdata@ragdata.dev
