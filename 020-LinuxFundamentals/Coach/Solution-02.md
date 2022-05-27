# Challenge 02 - Handling directories - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance
1. Display your current directory

`student@vm01:~$ pwd`

```bash
/home/student
```

2. Go to the parent directory of the current directory

`student@vm01:~$ cd ..`

3. Go to the root directory

`student@vm01:~$ cd /`

4. Listing the contents of the root directory

`student@vm01:~$ ls`

```bash
bin  boot  dev  etc  home  lib  lib32  lib64  libx32  lost+found  media  mnt  opt  proc  root  run  sbin  snap  srv  sys  tmp  usr  var
```

5. Display a long listing of the root directory

`student@vm01:~$ ls -l`

```bash
total 64
lrwxrwxrwx   1 root root     7 Apr  4 21:39 bin -> usr/bin
drwxr-xr-x   4 root root  4096 Apr  4 21:57 boot
drwxr-xr-x  18 root root  4100 Apr  7 01:04 dev
drwxr-xr-x 102 root root  4096 Apr  7 06:18 etc
drwxr-xr-x   4 root root  4096 Apr  6 15:06 home
lrwxrwxrwx   1 root root     7 Apr  4 21:39 lib -> usr/lib
lrwxrwxrwx   1 root root     9 Apr  4 21:39 lib32 -> usr/lib32
lrwxrwxrwx   1 root root     9 Apr  4 21:39 lib64 -> usr/lib64
lrwxrwxrwx   1 root root    10 Apr  4 21:39 libx32 -> usr/libx32
drwx------   2 root root 16384 Apr  4 21:42 lost+found
drwxr-xr-x   2 root root  4096 Apr  4 21:39 media
drwxr-xr-x   5 root root  4096 Apr  6 16:08 mnt
drwxr-xr-x   5 root root  4096 Apr  6 15:06 opt
dr-xr-xr-x 183 root root     0 Apr  7 00:28 proc
drwx------   5 root root  4096 Apr  6 15:12 root
drwxr-xr-x  26 root root   940 Apr  8 00:09 run
lrwxrwxrwx   1 root root     8 Apr  4 21:39 sbin -> usr/sbin
drwxr-xr-x   6 root root  4096 Apr  4 21:41 snap
drwxr-xr-x   2 root root  4096 Apr  4 21:39 srv
dr-xr-xr-x  12 root root     0 Apr  7 00:28 sys
drwxrwxrwt  12 root root  4096 Apr  8 00:00 tmp
drwxr-xr-x  14 root root  4096 Apr  4 21:40 usr
drwxr-xr-x  13 root root  4096 Apr  4 21:41 var
```

6. Stay where you are, and list the contents of ~

`student@vm01:~$ ls ~`

7.  List all the files (including hidden files) in your home directory

`student@vm01:~$ ls -al ~`

```bash
total 40
drwxr-xr-x 4 student student 4096 Apr  8 00:12 .
drwxr-xr-x 4 root      root      4096 Apr  6 15:06 ..
-rw------- 1 student student 2201 Apr  8 00:09 .bash_history
-rw-r--r-- 1 student student  220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 student student 3771 Feb 25  2020 .bashrc
drwx------ 2 student student 4096 Apr  6 15:03 .cache
-rw-r--r-- 1 student student  807 Feb 25  2020 .profile
drwx------ 2 student student 4096 Apr  6 15:02 .ssh
-rw-r--r-- 1 student student    0 Apr  6 15:05 .sudo_as_admin_successful
-rw------- 1 student student  786 Apr  7 22:10 .viminfo
-rw-rw-r-- 1 student student  252 Apr  8 00:01 .wget-hsts
```

8. Use a single command to create the following directory tree `~/folder1/folder2/folder3` (folder3 is a subdirectory from folder2, and folder2 is a subdirectory from folder1)

`student@vm01:~$ mkdir -p ~/folder1/folder2/folder3`

9. List recursively the content of your ~ 

`student@vm01:~$ ls -R`

```bash
/home/student:
dir1

/home/student/dir1:
dir2

/home/student/dir1/dir2:
dir3

/home/student/dir1/dir2/dir3:
```

10. Find the directories within your home folder

`student@vm01:~$ find ~ -type d`

```bash
/home/student
/home/student/.cache
/home/student/.ssh
/home/student/dir1
/home/student/dir1/dir2
/home/student/dir1/dir2/dir3
```
