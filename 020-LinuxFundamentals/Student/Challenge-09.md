# Challenge 09 - Disks, Partitions and File Systems

[< Previous Challenge](./Challenge-08.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-10.md)

## Pre-requisites 

- Create a data disk with the size of 5GB
- Add the disk the the virtual machine 

## Description

This challenge you will be working with disks and partitions. Will be an opportunity to learn about Linux filesystems and commands such as `fdisk`, `mkfs` and `mount`.

- Identify the new disk added to the machine
- Edit the disk partition table:
    - Add a new partition with 500MB
    - List and identify in the operating system the partition created
    - Erase partition
    - Check in the operating system that the partition has been removed
    - Add two new partitions with a native Linux partition (83), one with 500MB and another with 100MB
    - Check in the operating system that the partitions were created
- Create a file system on each of the partitions created
- Create a directory for each of the partitions inside the `/mnt` directory
- Mount each of the partitions in the respective directory
- Verify that the partitions are mounted correctly whithin the operational system.
- Write files inside one of the partitions
- Unmount the partitions
- Remove existing partitions

## Success Criteria

1. Check if the disk was added to the virtual machine
2. Make sure you created the partitions as expected
3. Validate on both partitions the file system created 
4. Make sure you have created the the respective directories inside `mnt` directory
5. Make sure the partitions are properly mounted
6. Ensure you can create files on the partitions
7. Make sure you unmonted the partitions and removed both properly

## Learning Resources

- [Filesystem Hierarchy](https://linuxjourney.com/lesson/filesystem-hierarchy)
- [Dev Directory](https://linuxjourney.com/lesson/dev-directory)
- [How to partition a disk in Linux](https://opensource.com/article/18/6/how-partition-disk-linux)
- [How To – Linux List Disk Partitions Command](https://www.cyberciti.biz/faq/linux-list-disk-partitions-command/)
- [How To List Disk Partitions In Linux](https://ostechnix.com/how-to-list-disk-partitions-in-linux/)

