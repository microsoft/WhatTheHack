# Package Management

## Objectives

#### 1. Update the package distribution lists

`student@vm1:~$ sudo apt update`

```bash
Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
Hit:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
Hit:4 http://azure.archive.ubuntu.com/ubuntu focal-security InRelease
Reading package lists... Done
Building dependency tree
Reading state information... Done
3 packages can be upgraded. Run 'apt list --upgradable' to see them
```

#### 2. Update the packages installed at your virtual machine

`student@vm1:~$ sudo apt update`

```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
Calculating upgrade... Done
The following packages were automatically installed and are no longer required:
  apache2-bin apache2-data apache2-utils javascript-common libapache2-mod-php7.4 libapr1 libaprutil1
  libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 libjs-jquery liblua5.2-0 php php-common php-xml php7.4
  php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-xml ssl-cert
Use 'sudo apt autoremove' to remove them.
The following packages will be upgraded:
  libarchive13 open-vm-tools tcpdump
3 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
2 standard security updates
Need to get 974 kB/1344 kB of archives.
After this operation, 952 kB of additional disk space will be used.
Do you want to continue? [Y/n]
(Reading database ... 69018 files and directories currently installed.)
Preparing to unpack .../open-vm-tools_2%3a11.3.0-2ubuntu0~ubuntu20.04.2_amd64.deb ...
Unpacking open-vm-tools (2:11.3.0-2ubuntu0~ubuntu20.04.2) over (2:11.0.5-4) ...
Preparing to unpack .../tcpdump_4.9.3-4ubuntu0.1_amd64.deb ...
Unpacking tcpdump (4.9.3-4ubuntu0.1) over (4.9.3-4) ...
Preparing to unpack .../libarchive13_3.4.0-2ubuntu1.2_amd64.deb ...
Unpacking libarchive13:amd64 (3.4.0-2ubuntu1.2) over (3.4.0-2ubuntu1.1) ...
Setting up tcpdump (4.9.3-4ubuntu0.1) ...
Setting up libarchive13:amd64 (3.4.0-2ubuntu1.2) ...
Setting up open-vm-tools (2:11.3.0-2ubuntu0~ubuntu20.04.2) ...
Installing new version of config file /etc/vmware-tools/tools.conf.example ...
Installing new version of config file /etc/vmware-tools/vgauth.conf ...
Removing obsolete conffile /etc/vmware-tools/vm-support ...
Processing triggers for systemd (245.4-4ubuntu3.15) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.7) ...
```

#### 3. Install the following packages
1. git
    
`student@vm1:~$ sudo apt install git` 
    
```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  git-daemon-run | git-daemon-sysvinit git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn
The following NEW packages will be installed:
  git
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 4554 kB of archives.
After this operation, 36.5 MB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 git amd64 1:2.25.1-1ubuntu3.2 [4554 kB]
Fetched 4554 kB in 0s (41.4 MB/s)
Selecting previously unselected package git.
(Reading database ... 67607 files and directories currently installed.)
Preparing to unpack .../git_1%3a2.25.1-1ubuntu3.2_amd64.deb ...
Unpacking git (1:2.25.1-1ubuntu3.2) ...
Setting up git (1:2.25.1-1ubuntu3.2) ...
```
2. net-tools

`student@vm1:~$ sudo apt install net-tools` 
    
```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  net-tools
  0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 196 kB of archives. 
After this operation, 864 kB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 net-tools amd64 1.60+git20180626.aebd88e-1ubuntu1 [196 kB]
Fetched 196 kB in 0s (5872 kB/s)
Selecting previously unselected package net-tools.
(Reading database ... 68305 files and directories currently installed.)
Preparing to unpack .../net-tools_1.60+git20180626.aebd88e-1ubuntu1_amd64.deb ...
Unpacking net-tools (1.60+git20180626.aebd88e-1ubuntu1) ...
Setting up net-tools (1.60+git20180626.aebd88e-1ubuntu1) ...
Processing triggers for man-db (2.9.1-1) ...
```
3. nginx

`student@vm1:~$ sudo apt install nginx-core` 
    
```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg-turbo8 libjpeg8
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5 libwebp6
  libxpm4 nginx-common
Suggested packages:
  libgd-tools fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  fontconfig-config fonts-dejavu-core libfontconfig1 libgd3 libjbig0 libjpeg-turbo8 libjpeg8
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter libnginx-mod-mail libnginx-mod-stream libtiff5 libwebp6
  libxpm4 nginx-common nginx-core
Preparing to unpack .../07-libtiff5_4.1.0+git191117-2ubuntu0.20.04.2_amd64.deb ...
Unpacking libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...
Selecting previously unselected package libxpm4:amd64.
Preparing to unpack .../08-libxpm4_1%3a3.5.12-1_amd64.deb ...
Unpacking libxpm4:amd64 (1:3.5.12-1) ...
Selecting previously unselected package libgd3:amd64.
Preparing to unpack .../09-libgd3_2.2.5-5.2ubuntu2.1_amd64.deb ...
Unpacking libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...
Selecting previously unselected package nginx-common.
Preparing to unpack .../10-nginx-common_1.18.0-0ubuntu1.3_all.deb ...
Unpacking nginx-common (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libnginx-mod-http-image-filter.
Preparing to unpack .../11-libnginx-mod-http-image-filter_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-http-image-filter (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libnginx-mod-http-xslt-filter.
Preparing to unpack .../12-libnginx-mod-http-xslt-filter_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libnginx-mod-mail.
Preparing to unpack .../13-libnginx-mod-mail_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-mail (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package libnginx-mod-stream.
Preparing to unpack .../14-libnginx-mod-stream_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking libnginx-mod-stream (1.18.0-0ubuntu1.3) ...
Selecting previously unselected package nginx-core.
Preparing to unpack .../15-nginx-core_1.18.0-0ubuntu1.3_amd64.deb ...
Unpacking nginx-core (1.18.0-0ubuntu1.3) ...
Setting up libxpm4:amd64 (1:3.5.12-1) ...
Setting up nginx-common (1.18.0-0ubuntu1.3) ...
Setting up libjbig0:amd64 (2.1-3.1build1) ...
Setting up libnginx-mod-http-xslt-filter (1.18.0-0ubuntu1.3) ...##..................................................]
Setting up libwebp6:amd64 (0.6.1-2ubuntu0.20.04.1) ...
Setting up fonts-dejavu-core (2.37-1) ...
Setting up libjpeg-turbo8:amd64 (2.0.3-0ubuntu1.20.04.1) ...
Setting up libjpeg8:amd64 (8c-2ubuntu8) ...
Setting up libnginx-mod-mail (1.18.0-0ubuntu1.3) ...
Setting up fontconfig-config (2.13.1-2ubuntu3) ...
Setting up libnginx-mod-stream (1.18.0-0ubuntu1.3) ...
Setting up libtiff5:amd64 (4.1.0+git191117-2ubuntu0.20.04.2) ...
Setting up libfontconfig1:amd64 (2.13.1-2ubuntu3) ...
Setting up libgd3:amd64 (2.2.5-5.2ubuntu2.1) ...
Setting up libnginx-mod-http-image-filter (1.18.0-0ubuntu1.3) ...
Setting up nginx-core (1.18.0-0ubuntu1.3) ...
Processing triggers for ufw (0.36-6ubuntu1) ...
Processing triggers for systemd (245.4-4ubuntu3.15) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.7) ...
```

#### 4. Uninstall the package named nano

`student@vm1:~$ sudo apt uninstall nano` 
    
```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be REMOVED:
  nano
0 upgraded, 0 newly installed, 1 to remove and 0 not upgraded.
After this operation, 868 kB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 68420 files and directories currently installed.)
Removing nano (4.8-1ubuntu1) ...
update-alternatives: using /usr/bin/vim.basic to provide /usr/bin/editor (editor) in auto mode
Processing triggers for install-info (6.7.0.dfsg.2-5) ...
Processing triggers for man-db (2.9.1-1) ...
```

#### 5. Show packate details for vim

`student@vm1:~$ sudo apt show  vim` 
    
```bash
Package: vim
Version: 2:8.1.2269-1ubuntu5.7
Priority: optional
Section: editors
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Debian Vim Maintainers <pkg-vim-maintainers@lists.alioth.debian.org>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 3112 kB
Provides: editor
Depends: vim-common (= 2:8.1.2269-1ubuntu5.7), vim-runtime (= 2:8.1.2269-1ubuntu5.7), libacl1 (>= 2.2.23), libc6 (>= 2.29), libcanberra0 (>= 0.2), libgpm2 (>= 1.20.7), libpython3.8 (>= 3.8.2), libselinux1 (>= 1.32), libtinfo6 (>= 6)
Suggests: ctags, vim-doc, vim-scripts
Homepage: https://www.vim.org/
Task: server, cloud-image, lubuntu-desktop
Download-Size: 1238 kB
APT-Manual-Installed: yes
APT-Sources: http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages
Description: Vi IMproved - enhanced vi editor
 Vim is an almost compatible version of the UNIX editor Vi.
 .
 Many new features have been added: multi level undo, syntax
 highlighting, command line history, on-line help, filename
 completion, block operations, folding, Unicode support, etc.
 .
 This package contains a version of vim compiled with a rather
 standard set of features.  This package does not provide a GUI
 version of Vim.  See the other vim-* packages if you need more
 (or less).
```

#### 6. Search for docker at the packages list and install the Linux container runtime

`student@vm1:~$ sudo apt search docker` 
    
```bash
Sorting... Done
Full Text Search... Done
amazon-ecr-credential-helper/focal 0.3.1-1 amd64
  Amazon ECR Credential Helper for Docker

auto-apt-proxy/focal 12 all
  automatic detector of common APT proxy settings

cadvisor/focal 0.27.1+dfsg2-4 amd64
  analyze resource usage and performance characteristics of running containers

ctop/focal 1.0.0-2 all
  Command line / text based Linux Containers monitoring tool

debocker/focal 0.2.3 all
  docker-powered package builder for Debian

debootstick/focal 2.4 amd64
  Turn a chroot environment into a bootable image

debuerreotype/focal 0.10-1 all
  reproducible, snapshot-based Debian rootfs builder

docker/focal 1.5-2 all
  transitional package

docker-compose/focal 1.25.0-1 all
  Punctual, lightweight development environments using Docker

docker-doc/focal-updates,focal-security 20.10.7-0ubuntu5~20.04.2 all
  Linux container runtime -- documentation

docker-registry/focal 2.7.1+ds2-7 amd64
  Docker toolset to pack, ship, store, and deliver content

docker.io/focal-updates,focal-security 20.10.7-0ubuntu5~20.04.2 amd64
  Linux container runtime

docker2aci/focal 0.17.2+dfsg-2 amd64
  CLI tool to convert Docker images to ACIs

dumb-init/focal 1.2.2-1.2 amd64
  wrapper script which proxies signals to a child

fence-agents/focal-updates 4.5.2-1ubuntu0.1 amd64
  Fence Agents for Red Hat Cluster

gnome-shell-extension-hide-veth/focal 1.0.2-1 all
  hides veth devices typically used by docker and lxc

golang-docker-credential-helpers/focal 0.6.3-1 amd64
  native stores to safeguard Docker credentials

golang-docker-dev/focal-updates,focal-security 20.10.7-0ubuntu5~20.04.2 all
  Transitional package for golang-github-docker-docker-dev

golang-github-appc-docker2aci-dev/focal 0.17.2+dfsg-2 all
  library to convert Docker images to ACIs

golang-github-containers-image-dev/focal 4.0.1-1 all
  golang library to work with containers' images

golang-github-crossdock-crossdock-go-dev/focal 0.0~git20160816.049aabb-2 all
  Go client for Crossdock

golang-github-docker-containerd-dev/focal-updates,focal-security 1.5.2-0ubuntu1~20.04.3 all
  Transitional package for golang-github-containerd-containerd-dev

golang-github-docker-distribution-dev/focal 2.7.1+ds2-7 all
  Docker toolset to pack, ship, store, and deliver content (source)

golang-github-docker-docker-credential-helpers-dev/focal 0.6.3-1 all
  native stores to safeguard Docker credentials - library

golang-github-docker-docker-dev/focal-updates,focal-security 20.10.7-0ubuntu5~20.04.2 all
  Externally reusable Go packages included with Docker

golang-github-docker-engine-api-dev/focal 0.4.0-4 all
  client and server components compatible with the Docker engine

golang-github-docker-go-connections-dev/focal 0.4.0-1 all
  Golang utility package to work with network connections

golang-github-docker-go-dev/focal 0.0~git20160303.0.d30aec9-3 all
  Go packages with small patches autogenerated (used for canonical/json)

golang-github-docker-go-events-dev/focal 0.0~git20170721.0.9461782-1 all
  Composable event distribution for Go

golang-github-docker-go-metrics-dev/focal 0.0~git20180209.399ea8c-1 all
  Package for metrics collection in Docker projects

golang-github-docker-go-units-dev/focal 0.4.0-3 all
  parse and print size and time units in human-readable format

golang-github-docker-goamz-dev/focal 0.0~git20160206.0.f0a21f5-3 all
  Enable Go programs to interact with Amazon Web Services

golang-github-docker-leadership-dev/focal 0.1.0-1 all
  distributed leader election using docker/libkv

golang-github-docker-libkv-dev/focal 0.2.1-1 all
  Key/Value store abstraction library

golang-github-docker-libtrust-dev/focal 0.0~git20150526.0.9cbd2a1-3 all
  Primitives for identity and authorization

golang-github-docker-notary-dev/focal 0.6.1~ds2-5 all
  library for running and interacting with trusted collections

golang-github-docker-spdystream-dev/focal 0.0~git20181023.6480d4a-1 all
  multiplexed stream library using spdy

golang-github-fsouza-go-dockerclient-dev/focal 1.6.0-2 all
  Docker client library in Go

golang-github-google-cadvisor-dev/focal 0.27.1+dfsg2-4 all
  analyze resource usage and performance of running containers

golang-github-hashicorp-go-reap-dev/focal 0.0~git20160113.0.2d85522-3 all
  child process reaping utilities for Go

golang-github-jfrazelle-go-dev/focal 0.0~git20160303.0.d30aec9-3 all
  Transitional package for golang-github-docker-go-dev

golang-github-mrunalp-fileutils-dev/focal 0.0~git20160930.0.4ee1cc9-1 all
  collection of utilities for file manipulation in golang

golang-github-opencontainers-runc-dev/focal-updates 1.0.1-0ubuntu2~20.04.1 all
  Open Container Project - development files

golang-github-openshift-imagebuilder-dev/focal 1.1.0-2 all
  Builds container images using Dockerfile as imput

golang-github-rkt-rkt-dev/focal 1.30.0+dfsg1-9 all
  rkt API source

golang-github-samalba-dockerclient-dev/focal 0.0~git20160531.0.a303626-2 all
  Docker client library in Go

golang-github-vishvananda-netlink-dev/focal 1.1.0-1 all
  netlink library for go

gosu/focal-updates 1.10-1ubuntu0.20.04.1 amd64
  Simple Go-based setuid+setgid+setgroups+exec

itamae/focal 1.9.10-2 all
  Simple Configuration Management Tool

karbon/focal 1:3.1.0+dfsg-6ubuntu7 amd64
  vector graphics application for the Calligra Suite

kdocker/focal 5.0-1.1 amd64
  lets you dock any application into the system tray

libcib27/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager CIB library

libcrmcluster29/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager cluster library

libcrmcommon34/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager common library

libcrmservice28/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager service library

libghc-pid1-dev/focal 0.1.2.0-3build3 amd64
  signal handling and orphan reaping for Unix PID1 init processes

libghc-pid1-doc/focal 0.1.2.0-3build3 all
  signal handling and orphan reaping for Unix PID1 init processes; documentation

libghc-pid1-prof/focal 0.1.2.0-3build3 amd64
  signal handling and orphan reaping for Unix PID1 init processes; profiling libraries

liblrmd28/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager LRMD library

libnss-docker/focal 0.02-1 amd64
  nss module for finding Docker containers

libpacemaker1/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager utility library

libpe-rules26/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager Policy Engine rules library

libpe-status28/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager Policy Engine status library

libstonithd26/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager STONITH daemon library

magnum-api/focal-updates 10.0.0-0ubuntu0.20.04.2 all
  OpenStack containers as a service

magnum-common/focal-updates 10.0.0-0ubuntu0.20.04.2 all
  OpenStack containers as a service - API server

magnum-conductor/focal-updates 10.0.0-0ubuntu0.20.04.2 all
  OpenStack containers as a service - conductor

needrestart/focal 3.4-6 all
  check which daemons need to be restarted after library upgrades

nomad/focal 0.8.7+dfsg1-1ubuntu1 amd64
  distributed, highly available, datacenter-aware scheduler

openscap-daemon/focal 0.1.10-3 all
  Daemon for infrastructure continuous SCAP compliance checks

openshift-imagebuilder/focal 1.1.0-2 amd64
  Builds container images using Dockerfile as imput

ovn-docker/focal-updates 20.03.2-0ubuntu0.20.04.3 amd64
  OVN Docker drivers

pacemaker/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager

pacemaker-cli-utils/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager command line utilities

pacemaker-common/focal-updates 2.0.3-3ubuntu4.3 all
  cluster resource manager common files

pacemaker-dev/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager development

pacemaker-doc/focal-updates 2.0.3-3ubuntu4.3 all
  cluster resource manager HTML documentation

pacemaker-remote/focal-updates 2.0.3-3ubuntu4.3 amd64
  cluster resource manager proxy daemon for remote nodes

pacemaker-resource-agents/focal-updates 2.0.3-3ubuntu4.3 all
  cluster resource manager general resource agents

pid1/focal 0.1.2.0-3build3 amd64
  signal handling and orphan reaping for Unix PID1 init processes

pidgin/focal 1:2.13.0-2.2ubuntu4 amd64
  graphical multi-protocol instant messaging client

puppet-module-magnum/focal 15.4.0-2 all
  Puppet module for OpenStack Magnum

python-magnumclient-doc/focal 2.11.0-0ubuntu4 all
  client library for Magnum API - doc

python3-ck/focal 1.9.4-1.1 all
  Python3 light-weight knowledge manager

python3-docker/focal 4.1.0-1 all
  Python 3 wrapper to access docker.io's control socket

python3-dockerpty/focal 0.4.1-2 all
  Pseudo-tty handler for docker Python client (Python 3.x)

python3-dockerpycreds/focal 0.3.0-1.1 all
  Python3 bindings for the docker credentials store API

python3-magnum/focal-updates 10.0.0-0ubuntu0.20.04.2 all
  OpenStack containers as a service - Python 3 library

python3-magnum-ui/focal 5.2.0-1 all
  OpenStack Magnum - dashboard plugin

python3-magnumclient/focal 2.11.0-0ubuntu4 all
  client library for Magnum API - Python 3.x

r-cran-batchtools/focal 0.9.12-1 amd64
  GNU R tools for computation on batch systems

rawdns/focal 1.6~ds1-1 amd64
  raw DNS interface to the Docker API

resource-agents/focal-updates 1:4.5.0-2ubuntu2.2 amd64
  Cluster Resource Agents

rkt/focal 1.30.0+dfsg1-9 amd64
  CLI for running App Containers

ruby-docker-api/focal 1.22.2-1 all
  Ruby gem to interact with docker.io remote API

ruby-kitchen-docker/focal 2.7.0-1 all
  Docker Driver for Test Kitchen

sen/focal 0.6.1-0.1 all
  Terminal user interface for docker engine

subuser/focal 0.6.2-3 all
  Run programs on Linux with selectively restricted permissions

test-kitchen/focal 1.23.2-5 all
  integration tool for Chef

vim-syntastic/focal 3.10.0-2 all
  Syntax checking hacks for vim

vim-syntax-docker/focal-updates,focal-security 20.10.7-0ubuntu5~20.04.2 all
  Docker container engine - Vim highlighting syntax files

wait-for-it/focal 0.0~git20180723-1 all
  script that will wait on the availability of a host and TCP port

whalebuilder/focal 0.8 all
  Debian package builder using Docker

wmdocker/focal 1.5-2 amd64
  System tray for KDE3/GNOME2 docklet applications
  ```
  
  
`student@vm1:~$ sudo apt install docker.io` 

```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  aufs-tools cgroupfs-mount | cgroup-lite debootstrap docker-doc rinse zfs-fuse | zfsutils
The following NEW packages will be installed:
  docker.io
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 36.9 MB of archives.
After this operation, 193 MB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal-updates/universe amd64 docker.io amd64 20.10.7-0ubuntu5~20.04.2 [36.9 MB]
Fetched 36.9 MB in 1s (25.7 MB/s)
Preconfiguring packages ...
Selecting previously unselected package docker.io.
(Reading database ... 68500 files and directories currently installed.)
Preparing to unpack .../docker.io_20.10.7-0ubuntu5~20.04.2_amd64.deb ...
Unpacking docker.io (20.10.7-0ubuntu5~20.04.2) ...
Setting up docker.io (20.10.7-0ubuntu5~20.04.2) ...
Processing triggers for man-db (2.9.1-1) ...
```

---
[Back](../README.md)| 
:----- |
