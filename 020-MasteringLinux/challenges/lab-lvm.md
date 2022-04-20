# 9 - Logical Volume Manager

## Description

This challenge will give to you understanding over the Logical Volume Manager on Linux, and knowledge using the commands `pvcreate`, `pvs`, `pvdisplay`, `vgcreate`, `vgs`, `lvrcreate`, `lvs`, `lvdisplay`, `mkfs`, `lvresize` and `resize2fs`

## Requirements

* Create a data disk
* Add to the Virtual Machine

## Success Criteria

1. Create a Physical Volume (`PV`) with the disk added
2. Check that the ```PV``` is created
3. Create a Volume Group (```VG```) using the created PV
4. Verify that the VG is created
5. Create a Logical Volume (```LV```) using half the disk
6. Create an ```LV``` using 10% of the disk
7. Verify that ```LV```s are created
8. Format both ```LV```s as ```ext4```
9. Mount the ```LV```s in the directories created earlier in ```/mnt```
10. Resize the smallest ```LV``` to take up another 20% of the disk
11. Check:
    1. That the ```LV``` has been resized
    2. If there was reflection in the file system
12. Resize the file system

## Learning resoures

* [Linux Commands Cheat Sheet](../resources/commands.md)
* Linx manual pages `man <command>`

---

[Back to main](../README.md)| [10 - Package management](../challenges/lab-packages.md) |
:----- |:---- |


