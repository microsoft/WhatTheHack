# Challenge 08 - Scripting - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance
1. Create a script that looks up the name of the current distribution in the `/etc/os-release` file and prints it to the screen

`student@vm01:~$ vim distribution.sh`

```bash
#!/bin/bash
distribution=`grep ^NAME /etc/os-release | cut -d= -f2`
echo "The current distribution is: $distribution"
```
`student@vm01:~$ chmod a+x distribution.sh`

`student@vm01:~$ ./distribution.sh`

```bash
The current distribution is: "Ubuntu"
```

2. Create a script that reads the usernames from `/etc/passwd` and prints the ones with shell ending in sh

`student@vm01:~$ vim users.sh`

```bash
#!/bin/bash
users=`grep sh$ /etc/passwd | cut -d: -f1`
echo "Users with login shell:"
echo $users
```
`student@vm01:~$ chmod a+x users.sh`

`student@vm01:~$ ./users.sh`

```bash
Users with login shell:
root student omsagent nxautomation anna mary peter rick"
```

3. Create a script that adds two integers requested from the user and print the sum

`student@vm01:~$ vim sum.sh`

```bash
#!/bin/bash
echo "Enter two numbers: "
read N1 N2
sum=$(( N1 + N2 ))
echo "The sum of $N1 and $N2 is $sum"
```
`student@vm01:~$ chmod a+x sum.sh`

`student@vm01:~$ ./sum.sh`

```bash
Enter two numbers:
2 3
The sum of 2 and 3 is 5
```
