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

    2. php-fpm

    `student@vm1:~$ sudo apt install net-tools` 
    
    ```bash
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following additional packages will be installed:
      libsodium23 php-common php7.2-cli php7.2-common php7.2-fpm php7.2-json php7.2-opcache php7.2-readline
    Suggested packages:
      php-pear
    The following NEW packages will be installed:
      libsodium23 php-common php-fpm php7.2-cli php7.2-common php7.2-fpm php7.2-json php7.2-opcache php7.2-readline
    0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
    Need to get 4070 kB of archives.
    After this operation, 17.7 MB of additional disk space will be used.
    Do you want to continue? [Y/n] y
    Get:1 http://azure.archive.ubuntu.com/ubuntu bionic/main amd64 libsodium23 amd64 1.0.16-2 [143 kB]
    Get:2 http://azure.archive.ubuntu.com/ubuntu bionic/main amd64 php-common all 1:60ubuntu1 [12.1 kB]
    Get:3 http://azure.archive.ubuntu.com/ubuntu bionic-updates/main amd64 php7.2-common amd64 7.2.24-0ubuntu0.18.04.11 [890 kB]
    Get:4 http://azure.archive.ubuntu.com/ubuntu bionic-updates/main amd64 php7.2-json amd64 7.2.24-0ubuntu0.18.04.11 [18.9 kB]
    Get:5 http://azure.archive.ubuntu.com/ubuntu bionic-updates/main amd64 php7.2-opcache amd64 7.2.24-0ubuntu0.18.04.11 [165 kB]
    Get:6 http://azure.archive.ubuntu.com/ubuntu bionic-updates/main amd64 php7.2-readline amd64 7.2.24-0ubuntu0.18.04.11 [12.2 kB]
    Get:7 http://azure.archive.ubuntu.com/ubuntu bionic-updates/main amd64 php7.2-cli amd64 7.2.24-0ubuntu0.18.04.11 [1411 kB]
    Get:8 http://azure.archive.ubuntu.com/ubuntu bionic-updates/universe amd64 php7.2-fpm amd64 7.2.24-0ubuntu0.18.04.11 [1414 kB]
    Get:9 http://azure.archive.ubuntu.com/ubuntu bionic/universe amd64 php-fpm all 1:7.2+60ubuntu1 [3172 B]
    Fetched 4070 kB in 0s (11.9 MB/s)
    Selecting previously unselected package libsodium23:amd64.
    (Reading database ... 59433 files and directories currently installed.)
    Preparing to unpack .../0-libsodium23_1.0.16-2_amd64.deb ...
    Unpacking libsodium23:amd64 (1.0.16-2) ...
    Selecting previously unselected package php-common.
    Preparing to unpack .../1-php-common_1%3a60ubuntu1_all.deb ...
    Unpacking php-common (1:60ubuntu1) ...
    Selecting previously unselected package php7.2-common.
    Preparing to unpack .../2-php7.2-common_7.2.24-0ubuntu0.18.04.11_amd64.deb ...
    Unpacking php7.2-common (7.2.24-0ubuntu0.18.04.11) ...
    Selecting previously unselected package php7.2-json.
    Preparing to unpack .../3-php7.2-json_7.2.24-0ubuntu0.18.04.11_amd64.deb ...
    Unpacking php7.2-json (7.2.24-0ubuntu0.18.04.11) ...
    Selecting previously unselected package php7.2-opcache.
    Preparing to unpack .../4-php7.2-opcache_7.2.24-0ubuntu0.18.04.11_amd64.deb ...
    Unpacking php7.2-opcache (7.2.24-0ubuntu0.18.04.11) ...
    Selecting previously unselected package php7.2-readline.
    Preparing to unpack .../5-php7.2-readline_7.2.24-0ubuntu0.18.04.11_amd64.deb ...
    Unpacking php7.2-readline (7.2.24-0ubuntu0.18.04.11) ...
    Selecting previously unselected package php7.2-cli.
    Preparing to unpack .../6-php7.2-cli_7.2.24-0ubuntu0.18.04.11_amd64.deb ...
    Unpacking php7.2-cli (7.2.24-0ubuntu0.18.04.11) ...
    Selecting previously unselected package php7.2-fpm.
    Preparing to unpack .../7-php7.2-fpm_7.2.24-0ubuntu0.18.04.11_amd64.deb ...
    Unpacking php7.2-fpm (7.2.24-0ubuntu0.18.04.11) ...
    Selecting previously unselected package php-fpm.
    Preparing to unpack .../8-php-fpm_1%3a7.2+60ubuntu1_all.deb ...
    Unpacking php-fpm (1:7.2+60ubuntu1) ...
    Setting up libsodium23:amd64 (1.0.16-2) ...
    Setting up php-common (1:60ubuntu1) ...
    Created symlink /etc/systemd/system/timers.target.wants/phpsessionclean.timer → /lib/systemd/system/phpsessionclean.timer.
    Setting up php7.2-common (7.2.24-0ubuntu0.18.04.11) ...

    Creating config file /etc/php/7.2/mods-available/calendar.ini with new version

    Creating config file /etc/php/7.2/mods-available/ctype.ini with new version

    Creating config file /etc/php/7.2/mods-available/exif.ini with new version

    Creating config file /etc/php/7.2/mods-available/fileinfo.ini with new version

    Creating config file /etc/php/7.2/mods-available/ftp.ini with new version

    Creating config file /etc/php/7.2/mods-available/gettext.ini with new version

    Creating config file /etc/php/7.2/mods-available/iconv.ini with new version

    Creating config file /etc/php/7.2/mods-available/pdo.ini with new version

    Creating config file /etc/php/7.2/mods-available/phar.ini with new version

    Creating config file /etc/php/7.2/mods-available/posix.ini with new version

    Creating config file /etc/php/7.2/mods-available/shmop.ini with new version

    Creating config file /etc/php/7.2/mods-available/sockets.ini with new version

    Creating config file /etc/php/7.2/mods-available/sysvmsg.ini with new version

    Creating config file /etc/php/7.2/mods-available/sysvsem.ini with new version

    Creating config file /etc/php/7.2/mods-available/sysvshm.ini with new version

    Creating config file /etc/php/7.2/mods-available/tokenizer.ini with new version
    Setting up php7.2-readline (7.2.24-0ubuntu0.18.04.11) ...

    Creating config file /etc/php/7.2/mods-available/readline.ini with new version
    Setting up php7.2-json (7.2.24-0ubuntu0.18.04.11) ...

    Creating config file /etc/php/7.2/mods-available/json.ini with new version
    Setting up php7.2-opcache (7.2.24-0ubuntu0.18.04.11) ...

    Creating config file /etc/php/7.2/mods-available/opcache.ini with new version
    Setting up php7.2-cli (7.2.24-0ubuntu0.18.04.11) ...
    update-alternatives: using /usr/bin/php7.2 to provide /usr/bin/php (php) in auto mode
    update-alternatives: using /usr/bin/phar7.2 to provide /usr/bin/phar (phar) in auto mode
    update-alternatives: using /usr/bin/phar.phar7.2 to provide /usr/bin/phar.phar (phar.phar) in auto mode

    Creating config file /etc/php/7.2/cli/php.ini with new version
    Setting up php7.2-fpm (7.2.24-0ubuntu0.18.04.11) ...

    Creating config file /etc/php/7.2/fpm/php.ini with new version
    Created symlink /etc/systemd/system/multi-user.target.wants/php7.2-fpm.service → /lib/systemd/system/php7.2-fpm.service.
    Setting up php-fpm (1:7.2+60ubuntu1) ...
    Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
    Processing triggers for ureadahead (0.100.0-21) ...
    Processing triggers for libc-bin (2.27-3ubuntu1.5) ...
    Processing triggers for systemd (237-3ubuntu10.53) ...
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

`student@vm1:~$ sudo apt remove nano` 
    
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
