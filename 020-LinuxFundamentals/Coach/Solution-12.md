# Challenge 12 - Setting up a WebServer - Coach's Guide 

[< Previous Solution](./Solution-11.md) - **[Home](./README.md)** - [Next Solution >](./Solution-13.md)

## Notes & Guidance
1. Download the sample application [from here](/Student/resources/simple-php-app.tar.gz) to your home directory

`student@vm01:~$ cd ~ ; wget https://aka.ms/linuxhack-simple-php-app -O simple-php-app.tar.gz`

2. Extract the content of simple-php-app.tar.gz on our home directory

`student@vm01:~$ tar xzvf simple-php-app.tar.gz`

```bash
simple-php-app/
simple-php-app/README.md
simple-php-app/assets/
simple-php-app/assets/css/
simple-php-app/assets/css/bootstrap-responsive.min.css
simple-php-app/assets/css/bootstrap.min.css
simple-php-app/assets/js/
simple-php-app/assets/js/bootstrap.min.js
simple-php-app/index.php
```

3. Install nginx

`student@vm01:~$ sudo apt install nginx-core`

```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  nginx-doc
The following NEW packages will be installed:
  nginx-core
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 425 kB of archives.
After this operation, 1250 kB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 nginx-core amd64 1.18.0-0ubuntu1.2 [425 kB]
Fetched 425 kB in 0s (11.0 MB/s)
Selecting previously unselected package nginx-core.
(Reading database ... 68923 files and directories currently installed.)
Preparing to unpack .../nginx-core_1.18.0-0ubuntu1.2_amd64.deb ...
Unpacking nginx-core (1.18.0-0ubuntu1.2) ...
Setting up nginx-core (1.18.0-0ubuntu1.2) ...
Processing triggers for man-db (2.9.1-1) ...
```

4. Install php-fpm

`student@vm01:~$ sudo apt install php-fpm`

```bash
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  php-common php7.4-cli php7.4-common php7.4-fpm php7.4-json php7.4-opcache php7.4-readline
Suggested packages:
  php-pear
The following NEW packages will be installed:
  php-common php-fpm php7.4-cli php7.4-common php7.4-fpm php7.4-json php7.4-opcache php7.4-readline
0 upgraded, 8 newly installed, 0 to remove and 0 not upgraded.
Need to get 4082 kB of archives.
After this operation, 18.1 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 php-common all 2:75 [11.9 kB]
Get:2 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 php7.4-common amd64 7.4.3-4ubuntu2.10 [981 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 php7.4-json amd64 7.4.3-4ubuntu2.10 [19.2 kB]
Get:4 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 php7.4-opcache amd64 7.4.3-4ubuntu2.10 [198 kB]
Get:5 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 php7.4-readline amd64 7.4.3-4ubuntu2.10 [12.6 kB]
Get:6 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 php7.4-cli amd64 7.4.3-4ubuntu2.10 [1422 kB]
Get:7 http://azure.archive.ubuntu.com/ubuntu focal-updates/universe amd64 php7.4-fpm amd64 7.4.3-4ubuntu2.10 [1434 kB]
Get:8 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 php-fpm all 2:7.4+75 [2792 B]
Fetched 4082 kB in 1s (3217 kB/s)
Selecting previously unselected package php-common.
(Reading database ... 68928 files and directories currently installed.)
Preparing to unpack .../0-php-common_2%3a75_all.deb ...
Unpacking php-common (2:75) ...
Selecting previously unselected package php7.4-common.
Preparing to unpack .../1-php7.4-common_7.4.3-4ubuntu2.10_amd64.deb ...
Unpacking php7.4-common (7.4.3-4ubuntu2.10) ...
Selecting previously unselected package php7.4-json.
Preparing to unpack .../2-php7.4-json_7.4.3-4ubuntu2.10_amd64.deb ...
Unpacking php7.4-json (7.4.3-4ubuntu2.10) ...
Selecting previously unselected package php7.4-opcache.
Preparing to unpack .../3-php7.4-opcache_7.4.3-4ubuntu2.10_amd64.deb ...
Unpacking php7.4-opcache (7.4.3-4ubuntu2.10) ...
Selecting previously unselected package php7.4-readline.
Preparing to unpack .../4-php7.4-readline_7.4.3-4ubuntu2.10_amd64.deb ...
Unpacking php7.4-readline (7.4.3-4ubuntu2.10) ...
Selecting previously unselected package php7.4-cli.
Preparing to unpack .../5-php7.4-cli_7.4.3-4ubuntu2.10_amd64.deb ...
Unpacking php7.4-cli (7.4.3-4ubuntu2.10) ...
Selecting previously unselected package php7.4-fpm.
Preparing to unpack .../6-php7.4-fpm_7.4.3-4ubuntu2.10_amd64.deb ...
Unpacking php7.4-fpm (7.4.3-4ubuntu2.10) ...
Selecting previously unselected package php-fpm.
Preparing to unpack .../7-php-fpm_2%3a7.4+75_all.deb ...
Unpacking php-fpm (2:7.4+75) ...
Setting up php-common (2:75) ...
Setting up php7.4-common (7.4.3-4ubuntu2.10) ...
Setting up php7.4-readline (7.4.3-4ubuntu2.10) ...
Setting up php7.4-opcache (7.4.3-4ubuntu2.10) ...
Setting up php7.4-json (7.4.3-4ubuntu2.10) ...
Setting up php7.4-cli (7.4.3-4ubuntu2.10) ...
update-alternatives: using /usr/bin/php7.4 to provide /usr/bin/php (php) in auto mode
update-alternatives: using /usr/bin/phar7.4 to provide /usr/bin/phar (phar) in auto mode
update-alternatives: using /usr/bin/phar.phar7.4 to provide /usr/bin/phar.phar (phar.phar) in auto mode
Setting up php7.4-fpm (7.4.3-4ubuntu2.10) ...

Creating config file /etc/php/7.4/fpm/php.ini with new version
Created symlink /etc/systemd/system/multi-user.target.wants/php7.4-fpm.service → /lib/systemd/system/php7.4-fpm.service.
Setting up php-fpm (2:7.4+75) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for systemd (245.4-4ubuntu3.15) ...
Processing triggers for php7.4-cli (7.4.3-4ubuntu2.10) ...
Processing triggers for php7.4-fpm (7.4.3-4ubuntu2.10) ...
```

5. Configure Nginx

`student@vm01:~$ cat <<'EOT' > ~/default`
```bash
# Nginx Config
server {
        listen 80;
        root /home/student/simple-php-app;
        index index.php index.html index.htm;
        server_name _;
 
        location / {
            try_files $uri $uri/ =404;
        }
 
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }
}
``` 
`EOT`

`student@vm01:~$ sudo cp ~/default /etc/nginx/sites-enabled/default`

`student@vm01:~$ sudo systemctl restart php7.4-fpm`

`student@vm01:~$ sudo systemctl restart nginx`

Remember to open port 80 on NSG

### Advanced challenge

To add SSL we will use [Certbot](https://certbot.eff.org/) to get a certificate from [Let's Encrypt](https://letsencrypt.org/). Here are the steps you need to follow:

* Ensure you have a valid domain with an A record pointing to the Virtual Machine Public IP. A valid domain with an A register defined is a pre-requisite for Certbot. You can use Azure App Service Domains to get a domain.  
    
* After addressing the previous step, you must adjust your Nginx config file `/etc/nginx/sites-enabled/default` setting the **server_name** directive to point to the name of your domain. Eg:
    
`student@vm01:~$ sudo sed -i.bkp -e 's/_;/linuxhackathon.com;/g' /etc/nginx/sites-enabled/default`

Then let's proceed to the setup and configurations for Certbot by setting new environment variables: 

```
export DOMAIN_NAME="linuxhackathon.com"
export EMAIL="admin@linuxhackathon.com"
````
_Remember to change according to your domain_

Install snap tool to get certbot:

`student@vm01:~$ sudo snap install core; sudo snap refresh core`

Install and configure Certbot:

`student@vm01:~$ sudo snap install --classic certbot` 

`student@vm01:~$ sudo certbot --nginx -d "${DOMAIN_NAME}" -m "${EMAIL}" --agree-tos -n` 

Restart Nginx:

`student@vm01:~$ sudo systemctl restart nginx` 

Remember to open the port 443 on the NSG
