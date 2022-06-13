# Linux Commands Cheat Sheet 

The command line terminal in Linux is the operating system’s most powerful component. However, due to the sheer amount of commands available, it can be intimidating for newcomers. Even longtime users may forget a command every once in a while and that is why we have created this Linux cheat sheet commands guide.

In this page, we’ll present you with a curated list of the most handy Linux commands. 

_Please note that those commands are for Linux in general, both RedHat-like and Debian-like distributions. There are some commands in the Package management session which may be specific for Redhat-based such as yum and rpm which do not work in Ubuntu (Debian-based)._

## File Commands

| Command | Description |
|--------------|--------------|
|`ls` | List files in the directory|
| `ls -a` | List all files (shows hidden files)|
| `locate [name]` | Find all files and directories related to a particular name: |
| `pwd` | Show directory you are currently working in |
| `mkdir [directory]` | Create a new directory |
| `rm [file_name]` | Remove a file |
| `rm -r [directory_name]`| Remove a directory recursively|
|`rm -rf [directory_name]`|Recursively remove a directory without requiring confirmation|
|`cp [file_name1] [file_name2]`|Copy the contents of one file to another file|
|`cp -r [directory_name1] [directory_name2]`|Recursively copy the contents of one file to a second file|
|`mv [file_name1] [file_name2]`|Rename [file_name1] to [file_name2] with the command|
|`ln -s /path/to/[file_name] [link_name]`|Create a symbolic link to a file|
| `touch [file_name]` | Create a new file using touch |
| `more [file_name]` | Show the contents of a file | 
| `cat [file_name]`  | or use the cat command |
| `cat [file_name1] >> [file_name2]` | Append file contents to another file | 
| `head [file_name]` | Display the first 10 lines of a file with head command | 
| `tail [file_name]` | Show the last 10 lines of a file | 
| `wc` | Show the number of words, lines, and bytes in a file using wc | 
| `ls \| xargs wc` | List number of lines/words/characters in each file in a directory with the xargs command | 
| `cut -d[delimiter] [filename]` | Cut a section of a file and print the result to standard output | 
| `[data] \| cut -d[delimiter]` | Cut a section of piped data and print the result to standard output | 
| `awk '[pattern] {print $0}' [filename]` | Print all lines matching a pattern in a file |
| `diff [file1] [file2]` | Compare two files and display differences| 
| `source [filename]` | Read and execute the file content in the current shell| 
| `[command] \| tee [filename] >/dev/null` | Store the command output in a file and skip the terminal output | 

## Searching

| Command | Description |
|--------------|--------------|
| `grep [pattern] [file_name]` | Search for a specific pattern in a file with grep |
| `grep -r [pattern] [directory_name]` | Recursively search for a pattern in a directory:|
| `locate [name]` | Find all files and directories related to a particular name: |
| `find [/folder/location] -name [a]` | List names that begin with a specified character [a] in a specified location [/folder/location] by using the find command: |
| `find [/folder/location] -size [+100M]` | See files larger than a specified size [+100M] in a folder: |

## Directory Navigation

| Command | Description |
|--------------|--------------|
|`tar cf [compressed_file.tar] [file_name]`|Archive an existing file|
|`tar xf [compressed_file.tar]`|Extract an archived file|
|`tar czf [compressed_file.tar.gz]`|Create a gzip compressed tar file by running|
|`gzip [file_name]`  | Compress a file with the .gz extension | 


## File Transfer

| Command | Description |
|--------------|--------------|
|`scp [file_name.txt] [server/tmp]`|Copy a file to a server directory securely using the Linux scp command|
|`rsync -a [/your/directory] [/backup/] `|Synchronize the contents of a directory with a backup directory using the rsync command|

## Users and Groups

| Command | Description |
|--------------|--------------|
|`id`|See details about the active users|
|`last`|Show last system logins|
|`who`|Display who is currently logged into the system with the who command|
|`w`  | Show which users are logged in and their activity | 
| `groupadd [group_name]` | Add a new group by typing |
| `adduser [user_name]` | Add a new user|
| `usermod -aG [group_name] [user_name]` | Add a user to a group |
| `sudo [command_to_be_executed_as_superuser]`| Temporarily elevate user privileges to superuser or root using the sudo command | 
| `userdel [user_name] ` | Delete a user | 
| `usermod`| Modify user information with |
| `chgrp [group-name] [directory-name]` | Change directory group|

## Package management

| Command | Description |
|--------------|--------------|
|`yum list installed`|List all installed packages with yum|
|`yum search [keyword]`|Find a package by a related keyword|
|`yum info [package_name]`|Show package information and summary|
|`yum install [package_name.rpm]`|Install a package using the YUM package manager|
|`dnf install [package_name.rpm]`|Install a package using the DNF package manager|
|`apt install [package_name]`|Install a package using the APT package manager|
|`rpm -i  [package_name.rpm]`|Install an .rpm package from a local file|
|`rpm -e [package_name.rpm]`|Remove an .rpm package|
|`dpkg -i [package_name.deb]`|Install an .deb package from a local file|
|`dpkg -r [package_name.deb]`|Remove an .deb package|
|`tar zxvf [source_code.tar.gz] && cd [source_code] && ./configure && make && make install`|Install software from source code|

## Process management

| Command | Description |
|--------------|--------------|
|`ps` | See a snapshot of active processes|
|`pstree`|Show processes in a tree-like diagram|
|`pmap`|Display a memory usage map of processes|
|`top`|See all running processes|
|`kill [process_id]` |Terminate a Linux process under a given ID |
|`pkill [proc_name]` | Terminate a process under a specific name|
|`killall [proc_name`|Terminate all processes labelled “proc”|
|`bg`|List and resume stopped jobs in the background|
|`fg`|Bring the most recently suspended job to the foreground|
|`fg [job]`|Bring a particular job to the foreground|
|`lsof`|List files opened by running processes|
|`trap "[commands-to-execute-on-trapping]" [signal]`|Catch a system error signal in a shell script|
|`wait`|Pause terminal or a Bash script until a running process is completed|
|`nohup [command] &`|Run a Linux process in the background|

## System Management and Information

| Command | Description |
|--------------|--------------|
|`uname -r` | Show system information|
|`uname -a`|See kernel release information|
|`uptime `|Display how long the system has been running, including load average|
|`hostname`|See system hostname|
|`hostname -i`|Show the IP address of the system|
|`last reboot`|List system reboot history|
|`date`|See current time and date|
|`timedatectl `|Query and change the system clock with|
|`cal`|Show current calendar (month and day)|
|`whoami`|See which user you are using|
|`finger [username]`|Show information about a particular user|
|`ulimit [flags] [limit]`|View or limit system resource amounts|
|`shutdown [hh:mm]`|Schedule a system shutdown|
|`shutdown now` |Shut Down the system immediately|

## Disk Usage

| Command | Description |
|--------------|--------------|
|`df -h`|See free and used space on mounted systems|
|`df -i`|Show free inodes on mounted filesystems|
|`fdisk -l`|Display disk partitions, sizes, and types with the command|
|`du -ah`|See disk usage for all files and directory|
|`du -sh`|Show disk usage of the directory you are currently in|
|`findmnt`|Display target mount point for all filesystem|
|`mount [device_path] [mount_point]` | Mount a device|


## SSH Login

| Command | Description |
|--------------|--------------|
|`ssh user@host`|Connect to host as user|
|`ssh host` | Securely connect to host via SSH default port 22| 
| `ssh -p [port] user@host` |Connect to host using a particular port|

## File Permission

| Command | Description |
|--------------|--------------|
|`chmod 777 [file_name]`|Assign read, write, and execute permission to everyone|
|`chmod 755 [file_name]`|Give read, write, and execute permission to owner, and read and execute permission to group and others|
|`chmod 766 [file_name]` | Assign full permission to owner, and read and write permission to group and others| 
|`chown [user] [file_name]`| Change the ownership of a file|
|`chown [user]:[group] [file_name]`|Change the owner and group ownership of a file|

## Network

| Command | Description |
|--------------|--------------|
|`ip addr show` | List IP addresses and network interfaces|
|`ip address add [IP_address]`| Assign an IP address to interface eth0|
|`ifconfig` | Display IP addresses of all network interfaces with|
|`netstat -pnltu` | See active (listening) ports with the netstat command|
| `netstat -nutlp` | Show tcp and udp ports and their programs|
| `whois [domain]` | Display more information about a domain|
| `dig [domain] ` | Show DNS information about a domain using the dig command|
| `dig -x host` | Do a reverse lookup on domain|
| `dig -x [ip_address]` | Do reverse lookup of an IP address|
| `host [domain]` | Perform an IP lookup for a domain|
| `hostname -I` | Show the local IP address|
| `wget [file_name]` | Download a file from a domain using the wget command|
| `nslookup [domain-name]` | Receive information about an internet domain|
| `curl -O [file-url]` | Save a remote file to your system using the filename that corresponds to the filename on the server|

## Variables

| Command | Description |
|--------------|--------------|
| `let "[variable]=[value]"`|Assign an integer value to a variable|
| `export [variable-name]` | Export a Bash variable| 
| `declare [variable-name]= "[value]"` | Declare a Bash variable|
| `set` | List the names of all the shell variables and functions|
| `echo $[variable-name]` | Display the value of a variable|

## Shell Command Management

| Command | Description |
|--------------|--------------|
| `alias [alias-name]='[command]'` | Create an alias for a command|
| `watch -n [interval-in-seconds] [command]` | Set a custom interval to run a user-defined command|
| `sleep [time-interval] && [command]` | Postpone the execution of a command|
| `at [hh:mm]` | Create a job to be executed at a certain time (Ctrl+D to exit prompt after you type in the command)|
| `man [command]` | Display a built-in manual for a command |
| `history` | Print the history of the commands you used in the terminal|

## Linux Keyboard Shortcuts

| Command | Description |
|--------------|--------------|
| `Ctrl + C` | Kill process running in the terminal|
| `Ctrl + Z` | Stop current process - The process can be resumed in the foreground with `fg` or in the background with `bg`|
| `Ctrl + W` | Cut one word before the cursor and add it to clipboard|
| `Ctrl + U` | Cut part of the line before the cursor and add it to clipboard |
| `Ctrl + K` | Cut part of the line after the cursor and add it to clipboard |
| `Ctrl + Y` | Paste from clipboard |
| `Ctrl + R` | Recall last command that matches the provided characters|
| `Ctrl + O` | Run the previously recalled command|
| `Ctrl + G` | Exit command history without running a command|
| `!!` | Run the last command again |
| `Ctrl + D | Log out of current session|

## Hardware information

| Command | Description |
|--------------|--------------|
|`dmesg` | Show bootup messages |
| `cat /proc/cpuinfo` | See CPU information|
| `free -h` | Display free and used memory |
| `lshw` | List hardware configuration information |
| `lsblk` | See information about block devices |
| `lspci -tv`| Show PCI devices in a tree-like diagram | 
| `dmidecode` |Show hardware information from the BIOS |
| `hdparm -i /dev/disk` | Display disk data information |
| `hdparm -tT /dev/[device]` | Conduct a read-speed test on device/disk |
| `fsck [disk-or-partition-location]`| Run a disk check on an unmounted disk or partition | 















