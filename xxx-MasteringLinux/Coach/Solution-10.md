# Challenge 10 - Logical volume manager - Coach's Guide 

[< Previous Solution](./Solution-09.md) - **[Home](./README.md)** - [Next Solution >](./Solution-11.md)

## Notes & Guidance
1. Create a Physical Volume (```PV```) with the disk added

`student@vm01:~$ sudo pvcreate /dev/sdc`

```bash
WARNING: dos signature detected on /dev/sdc at offset 510. Wipe it? [y/n]: y
  Wiping dos signature on /dev/sdc.
  Physical volume "/dev/sdc" successfully created.
```

2. Check that the ```PV``` is created

`student@vm01:~$ sudo pvs`

```bash
  PV         VG Fmt  Attr PSize PFree
  /dev/sdc      lvm2 ---  5.00g 5.00g
```

`student@vm01:~$ sudo pvdisplay /dev/sdc`

```bash
 "/dev/sdc" is a new physical volume of "5.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc
  VG Name
  PV Size               5.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               iofx4y-hjbo-vQda-mjZI-9mgn-Bw9B-SVAiYM
```

3. Create a Volume Group (```VG```) using the created PV

`student@vm01:~$ sudo vgcreate vg_data /dev/sdc`


```bash
Volume group "vg_data" successfully created
```

4. Verify that the VG is created

`student@vm01:~$ sudo vgs`

```bash
VG      #PV #LV #SN Attr   VSize  VFree
  vg_data   1   0   0 wz--n- <5.00g <5.00g
```

`student@vm01:~$ sudo vgdisplay vg_data`

```bash
--- Volume group ---
  VG Name               vg_data
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <5.00 GiB
  PE Size               4.00 MiB
  Total PE              1279
  Alloc PE / Size       0 / 0
  Free  PE / Size       1279 / <5.00 GiB
  VG UUID               2c7S20-cH8a-tRkt-ebKq-ym9X-rk1X-yiyOo1
```

5. Create a Logical Volume (```LV```) using half the disk (2.5GB)

`student@vm01:~$ sudo lvcreate -L 2.5G -n lv_part1 vg_data`

```bash
WARNING: ext4 signature detected on /dev/vg_data/lv_part1 at offset 1080. Wipe it? [y/n]: y
  Wiping ext4 signature on /dev/vg_data/lv_part1.
  Logical volume "lv_part1" created.
```

6. Create an ```LV``` using 10% of the disk (500MB)

`student@vm01:~$ sudo lvcreate -L 500M -n lv_part2 vg_data`

```bash
Rounding up size to full physical extent 52.00 MiB
WARNING: ext4 signature detected on /dev/vg_data/lv_part2 at offset 1080. Wipe it? [y/n]: y
  Wiping ext4 signature on /dev/vg_data/lv_part2.
  Logical volume "lv_part2" created.
```

7. Verify that ```LV```s are created

`student@vm01:~$ sudo lvs vg_data`

```bash
LV       VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_part1 vg_data -wi-a-----   2.50g
  lv_part2 vg_data -wi-a----- 500.00m
```

`student@vm01:~$ sudo lvdisplay vg_data`

```bash
 --- Logical volume ---
  LV Path                /dev/vg_data/lv_part1
  LV Name                lv_part1
  VG Name                vg_data
  LV UUID                Di9Ybv-hqu5-Bglc-BeDE-0WBk-UEE2-amGEaA
  LV Write Access        read/write
  LV Creation host, time vm01, 2022-04-07 01:03:56 +0000
  LV Status              available
  # open                 0
  LV Size                2.50 GiB
  Current LE             640
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/vg_data/lv_part2
  LV Name                lv_part2
  VG Name                vg_data
  LV UUID                1nWi5b-7zBH-RI2z-s5mA-qPz6-73fW-ee2Tu5
  LV Write Access        read/write
  LV Creation host, time vm01, 2022-04-07 01:04:08 +0000
  LV Status              available
  # open                 0
  LV Size                500.00 MiB
  Current LE             125
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
```

8. Format both ```LV```s as ```ext4```

`student@vm01:~$ sudo mkfs.ext4 /dev/vg_data/lv_part1`


```bash
mke2fs 1.45.5 (07-Jan-2020)
Discarding device blocks: done
Creating filesystem with 655360 4k blocks and 163840 inodes
Filesystem UUID: 3a182601-8faf-4c27-a055-0666373c8c99
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

`student@vm01:~$ sudo mkfs.ext4 /dev/vg_data/lv_part2`


```bash
mke2fs 1.45.5 (07-Jan-2020)
Discarding device blocks: done
Creating filesystem with 128000 4k blocks and 128000 inodes
Filesystem UUID: c8577667-00f7-4e4b-bf1d-a325113cc800
Superblock backups stored on blocks:
        32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```

9. Mount the ```LV```s in the directories created earlier in ```/mnt```

`student@vm01:~$ sudo mount /dev/vg_data/lv_part1 /mnt/dir1`

`student@vm01:~$ sudo mount /dev/vg_data/lv_part2 /mnt/dir2`

`student@vm01:~$ sudo mount | grep vg_data`

```bash
/dev/mapper/vg_data-lv_part1 on /mnt/dir1 type ext4 (rw,relatime)
/dev/mapper/vg_data-lv_part2 on /mnt/dir2 type ext4 (rw,relatime)
```

`student@vm01:~$ df -h /mnt/dir1 /mnt/dir2`

```bash
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/vg_data-lv_part1  2.4G  7.5M  2.3G   1% /mnt/dir1
/dev/mapper/vg_data-lv_part2  469M  768K  433M   1% /mnt/dir2
```

10. Resize the smallest ```LV``` to take up another 20% of the disk (1GB)

`student@vm01:~$ sudo lvresize -L +1G /dev/vg_data/lv_part2`

```bash
Size of logical volume vg_data/lv_part2 changed from 500.00 MiB (125 extents) to <1.49 GiB (381 extents).
  Logical volume vg_data/lv_part2 successfully resized.
```

11. Check:
    1. That the ```LV``` has been resized

    `student@vm01:~$ sudo lvs vg_data` 

    ```bash
    LV       VG      Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    lv_part1 vg_data -wi-ao----  2.50g
    lv_part2 vg_data -wi-ao---- <1.49g
    ```   

    2. If there was reflection in the file system

    `student@vm01:~$ df -h /mnt/dir1 /mnt/dir2` 

    ```bash
    Filesystem                    Size  Used Avail Use% Mounted on
    /dev/mapper/vg_data-lv_part1  2.4G  7.5M  2.3G   1% /mnt/dir1
    /dev/mapper/vg_data-lv_part2  469M  768K  433M   1% /mnt/dir2
    ```

12. Resize the file system

`student@vm01:~$ sudo resize2fs /dev/vg_data/lv_part2` 

```bash
resize2fs 1.45.5 (07-Jan-2020)
Filesystem at /dev/vg_data/lv_part2 is mounted on /mnt/dir2; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/vg_data/lv_part2 is now 390144 (4k) blocks long.
```

`student@vm01:~$ df -h /mnt/dir1 /mnt/dir2` 

```bash
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/vg_data-lv_part1  2.4G  7.5M  2.3G   1% /mnt/dir1
/dev/mapper/vg_data-lv_part2  1.5G  1.5M  1.4G   1% /mnt/dir2
```
