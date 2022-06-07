# Challenge 07 - Group and user management - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance
1. Create the groups: marketing, finance, apps and production

`student@vm01:~$ for name in marketing finance apps production; do sudo groupadd ${name}; done`

2. Create the users below with the given characteristics:

    1. login: anna, main group: marketing
  
    `student@vm01:~$ sudo useradd -c "Anna" -d /home/anna -m -s /bin/bash -g marketing anna`
  
    2. login: mary, main group: finance
  
    `student@vm01:~$ sudo useradd -c "Mary" -d /home/mary -m -s /bin/bash -g finance mary`
  
    3. login: peter, main group: apps
  
    `student@vm01:~$ sudo useradd -c "Peter" -d /home/peter -m -s /bin/bash -g apps peter`
  
    4. login: rick, main group: production
  
    `student@vm01:~$ sudo useradd -c "Rick" -d /home/rick -m -s /bin/bash -g production rick`
  
    Another way to create:
    ```bash
    student@vm01:~$ for usr in anna:marketing mary:finance peter:apps rick:prouction; do
    login=$(echo $usr | cut -d: -f1)
    group=$(echo $usr | cut -d: -f2)
    sudo useradd -c "$login" -d /home/$login -m -s /bin/bash -g $group $login
    done  
    ```
  
3. Create passwords for all users

`student@vm01:~$ sudo passwd anna`

`student@vm01:~$ sudo passwd mary`

`student@vm01:~$ sudo passwd peter`

`student@vm01:~$ sudo passwd rick`
