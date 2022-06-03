# Challenge 10 - Logical Volume Manager

[< Previous Challenge](./Challenge-09.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-11.md)

## Pre-requisites 

- Create a data disk of 5GB
- Add to the Virtual Machine

## Description

This challenge will give you an understanding over the Logical Volume Manager on Linux, and knowledge using the commands pvcreate, vgcreate, lvrcreate, and more

- Create a Physical Volume (`PV`) with the disk added
- Check that the ```PV``` is created
- Create a Volume Group (```VG```) using the created PV
- Verify that the VG is created
- Create a Logical Volume (```LV```) using half the disk (2.5GB)
- Create an ```LV``` using 10% of the disk (500MB)
- Verify that ```LV```s are created
- Format both ```LV```s as ```ext4```
- Mount the ```LV```s in the directories created earlier in ```/mnt```
- Resize the smallest ```LV``` to take up another 20% of the disk (1GB)
- Check:
    - That the ```LV``` has been resized
    - If there was reflection in the file system
- Resize the file system

## Success Criteria

1. Validate the creation of the Physical Volume
2. Validate the creation of the Volume Group
3. Validate the creation of the Logical Volume
4. Make sure both logical volumes were created with the expected sizes
5. Make sure both logical volumes were formated as ext4 file system
6. Confirm both logical volumes were properly mounted at `/mnt`
7. Show the logical volume and file system resized


## Learning Resources

- [LVM (Logical Volume Manager)](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/ch-lvm)
- [LVM Guide](https://linuxhandbook.com/lvm-guide/)
- [What is LVM (Logical Volume Management), and what are its Benefits?](https://linuxhint.com/whatis_logical_volume_management/)
- [Linux Logical Volume Manager (LVM) tutorial](https://linuxconfig.org/linux-lvm-logical-volume-manager)
- [A Beginner's Guide To LVM](https://www.howtoforge.com/linux_lvm)
