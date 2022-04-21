# Challenge 11 - Package Management - Coach's Guide 

[< Previous Solution](./Solution-10.md) - **[Home](./README.md)** - [Next Solution >](./Solution-12.md)

## Notes & Guidance
1. Update the package distribution lists

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

2. Upgrade the packages installed at your virtual machine

`student@vm1:~$ sudo apt upgrade`

```bash
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Calculating upgrade... Done
The following package was automatically installed and is no longer required:
  linux-headers-4.15.0-176
Use 'sudo apt autoremove' to remove it.
The following packages will be upgraded:
  bash
1 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
1 standard security update
Need to get 615 kB of archives.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n] y 
Get:1 http://azure.archive.ubuntu.com/ubuntu bionic-updates/main amd64 bash amd64 4.4.18-2ubuntu1.3 [615 kB]
Fetched 615 kB in 0s (14.8 MB/s)
(Reading database ... 77066 files and directories currently installed.)
Preparing to unpack .../bash_4.4.18-2ubuntu1.3_amd64.deb ...
Unpacking bash (4.4.18-2ubuntu1.3) over (4.4.18-2ubuntu1.2) ...
Setting up bash (4.4.18-2ubuntu1.3) ...
update-alternatives: using /usr/share/man/man7/bash-builtins.7.gz to provide /usr/share/man/man7/builtins.7.gz (builtins.7.gz) in auto mode
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
Processing triggers for install-info (6.5.0.dfsg.1-2) ...
```

3. Install the following packages

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

4. Uninstall the package named nano

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

5. Show packate details for vim

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

6. Search for docker at the packages list and install the Linux container runtime

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

...
...
...
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
