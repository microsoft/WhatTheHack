# Challenge 05 - Standard file permissions

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Description

In this challenge you will learn about the Linux standard file permissions and understand how to work with file permissioning on a Linux environment

- As regular user (student), create a directory `~/permissions`
- Create a file called `myfile.txt` under `~permissions`
- List the properties of the file `/var/log/waagent.log`. Then copy this file to your permissions directory
- As root, create a file called rootfile.txt in the `/home/student/permissions` directory
- As regular user (student), look at who owns this file created by root
- Change the ownership of all files in `/home/student/permissions` to yourself (student)
- Make sure you (student) have all rights to files within `~`, and others can only read

## Success Criteria

1. Check if the directory was sucessfully created
2. Confirm the file created under `~permissions`
3. Check the file inside your permissions directory. Who is the new owner of this file now?
4. Make sure you have created the file as the user root in the `/home/student/permissions` directory
5. Ensure you are logged as regular user (student), then check the owner of the file created by the user root
6. Validate you was able to change the onwership of all files in in `/home/student/permissions` to the user student
7. Confirm your rights within `~`, and make sure other users can only read


## Learning Resources

- [File Permissions](https://linuxjourney.com/lesson/file-permissions)
- [Understanding Linux File Permissions](https://www.linuxfoundation.org/blog/classic-sysadmin-understanding-linux-file-permissions/)
- [Chmod Calculator](https://chmod-calculator.com/)
- [Linux File Permissions](https://linuxhandbook.com/linux-file-permissions/)
- [Suid, Sgid, and Sticky Bit](https://linuxhandbook.com/suid-sgid-sticky-bit/)

