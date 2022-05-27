# Challenge 05 - Standard file permissions - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance
1. As a regular user (student), create a directory ~/permissions. 

`student@vm01:~$ mkdir ~/permissions`

2. Create a file called `myfile.txt` under `~permissions`.

`student@vm01:~$ touch ~/permissions/myfile.txt`

3. List the properties of the file `/var/log/waagent.log`. Then copy this file to your permissions directory. Who is the new owner of this file now?

`student@vm01:~$ ls -l /var/log/waagent.log`

```bash
-rw-r--r-- 1 root root 192274 Apr 11 17:07 /var/log/waagent.log
```

`student@vm01:~$ cp /var/log/waagent.log ~/permissions/`

`student@vm01:~$ ls -ls ~/permissions/`

```bash
-rw-r--r-- 1 student student      0 Apr  8 14:55 myfile.txt
-rw-r--r-- 1 student student 195022 Apr 11 19:51 waagent.log
```

4. As root, create a file called `rootfile.txt` in the `/home/student/permissions` directory.

`student@vm01:~$ sudo su`

`root@vm01:/# touch /home/student/permissions/rootfile`

5. As regular user (student), look at who owns this file created by root.

`root@vm01:/# exit`

`student@vm01:~$ ls -l ~/permissions`

```bash
total 4
-rw-rw-r-- 1 student student   0 Apr  8 14:55 myfile.txt
-rw-r--r-- 1 root      root        0 Apr  8 14:58 rootfile
-rw-r--r-- 1 student student 195022 Apr 11 19:51 waagent.log
```

6. Change the ownership of all files in `/home/student/permissions` to yourself (student).

`student@vm01:~$ chown student ~/permissions/*`

```bash
chown: changing ownership of '/home/student/permissions/rootfile': Operation not permitted
```
Note you cannot become owner of the file that belongs to root.

7. Make sure you (student) have all rights to files within `~`, and others can only read

`student@vm01:~$ find ~ -type d -exec chmod 755 {} \; `

`student@vm01:~$ find ~ -type f -exec chmod 644 {} \; `

```bash
chmod: changing permissions of '/home/student/permissions/rootfile': Operation not permitted
```
Note you cannot change permissions of the file that belongs to root.
