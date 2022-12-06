# Challenge 14 - Running Containers - Coach's Guide 
[< Previous Solution](./Solution-13.md) - **[Home](../README.md)** 

## Notes & Guidance

1. Install the docker runtime

`student@vm01:~$ sudo apt install docker.io`

```bash
The following NEW packages will be installed:
  bridge-utils containerd dns-root-data dnsmasq-base docker.io libidn11 pigz runc ubuntu-fan
0 upgraded, 9 newly installed, 0 to remove and 9 not upgraded.
Need to get 69.2 MB of archives.
After this operation, 334 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 pigz amd64 2.4-1 [57.4 kB]
Get:2 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 bridge-utils amd64 1.6-2ubuntu1 [30.5 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 runc amd64 1.1.0-0ubuntu1~20.04.1 [3892 kB]
Get:4 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 containerd amd64 1.5.9-0ubuntu1~20.04.4 [33.0 MB]
Get:5 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 dns-root-data all 2019052802 [5300 B]
Get:6 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 libidn11 amd64 1.33-2.2ubuntu2 [46.2 kB]
Get:7 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 dnsmasq-base amd64 2.80-1.1ubuntu1.5 [315 kB]
Get:8 http://azure.archive.ubuntu.com/ubuntu focal-updates/universe amd64 docker.io amd64 20.10.12-0ubuntu2~20.04.1 [31.8 MB]
Get:9 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 ubuntu-fan all 0.12.13ubuntu0.1 [34.4 kB]
Fetched 69.2 MB in 1s (48.4 MB/s)
Preconfiguring packages ...
Selecting previously unselected package pigz.
(Reading database ... 69090 files and directories currently installed.)
Preparing to unpack .../0-pigz_2.4-1_amd64.deb ...
Unpacking pigz (2.4-1) ...
Selecting previously unselected package bridge-utils.
Preparing to unpack .../1-bridge-utils_1.6-2ubuntu1_amd64.deb ...
Unpacking bridge-utils (1.6-2ubuntu1) ...
Selecting previously unselected package runc.
Preparing to unpack .../2-runc_1.1.0-0ubuntu1~20.04.1_amd64.deb ...
debug2: channel 0: window 999096 sent adjust 49480
Unpacking runc (1.1.0-0ubuntu1~20.04.1) ...
Selecting previously unselected package containerd.
Preparing to unpack .../3-containerd_1.5.9-0ubuntu1~20.04.4_amd64.deb ...
Unpacking containerd (1.5.9-0ubuntu1~20.04.4) ...
Selecting previously unselected package dns-root-data.
Preparing to unpack .../4-dns-root-data_2019052802_all.deb ...
Unpacking dns-root-data (2019052802) ...
Selecting previously unselected package libidn11:amd64.
Preparing to unpack .../5-libidn11_1.33-2.2ubuntu2_amd64.deb ...
Unpacking libidn11:amd64 (1.33-2.2ubuntu2) ...
Selecting previously unselected package dnsmasq-base.
Preparing to unpack .../6-dnsmasq-base_2.80-1.1ubuntu1.5_amd64.deb ...
Unpacking dnsmasq-base (2.80-1.1ubuntu1.5) ...
Selecting previously unselected package docker.io.
Preparing to unpack .../7-docker.io_20.10.12-0ubuntu2~20.04.1_amd64.deb ...
Unpacking docker.io (20.10.12-0ubuntu2~20.04.1) ...
Selecting previously unselected package ubuntu-fan.
Preparing to unpack .../8-ubuntu-fan_0.12.13ubuntu0.1_all.deb ...
Unpacking ubuntu-fan (0.12.13ubuntu0.1) ...
Setting up runc (1.1.0-0ubuntu1~20.04.1) ...
Setting up dns-root-data (2019052802) ...
Setting up libidn11:amd64 (1.33-2.2ubuntu2) ...
Setting up bridge-utils (1.6-2ubuntu1) ...
Setting up pigz (2.4-1) ...
Setting up containerd (1.5.9-0ubuntu1~20.04.4) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up docker.io (20.10.12-0ubuntu2~20.04.1) ...
Adding group `docker' (GID 121) ...
Done.
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
Setting up dnsmasq-base (2.80-1.1ubuntu1.5) ...
Setting up ubuntu-fan (0.12.13ubuntu0.1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/ubuntu-fan.service → /lib/systemd/system/ubuntu-fan.service.
Processing triggers for systemd (245.4-4ubuntu3.18) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for dbus (1.12.16-2ubuntu2.3) ...
Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
```

2. To run the Nginx container, execute the following command:

`student@vm01:~$ sudo docker run --name mynginx -p 8090:80 -d nginx`

```bash
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
e9995326b091: Pull complete
71689475aec2: Pull complete
f88a23025338: Pull complete
0df440342e26: Pull complete
eef26ceb3309: Pull complete
8e3ed6a9e43a: Pull complete
Digest: sha256:943c25b4b66b332184d5ba6bb18234273551593016c0e0ae906bab111548239f
Status: Downloaded newer image for nginx:latest
45628ca1834a818ff7512837e5036bd4532350db685b1049d7de663b133ddd32
```
3. Test if the container is running properly:

`student@vm01:~$ curl localhost:8090`

```bash
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

In the Network Security Group associated with your virtual machine, open the port 8090 and try access using the http://yourpublicip:8090

For the advanced challenge, here are the steps:

1. Download the sample application [from here](/Student/resources/simple-php-app.tar.gz) to your home directory

`student@vm01:~$ cd ~ ;  wget https://github.com/microsoft/WhatTheHack/blob/master/020-LinuxFundamentals/Student/resources/simple-php-app.tar.gz?raw=true -O simple-php-app.tar.gz`

```bash
--2022-11-09 01:46:30--  wget https://github.com/microsoft/WhatTheHack/blob/master/020-LinuxFundamentals/Student/resources/simple-php-app.tar.gz?raw=true
Resolving github.com (github.com)... 192.30.255.112
Connecting to github.com (github.com)|192.30.255.112|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: wget https://github.com/microsoft/WhatTheHack/blob/master/020-LinuxFundamentals/Student/resources/simple-php-app.tar.gz?raw=true [following]
--2022-11-09 01:46:30--  wget https://github.com/microsoft/WhatTheHack/blob/master/020-LinuxFundamentals/Student/resources/simple-php-app.tar.gz?raw=true
Reusing existing connection to github.com:443.
HTTP request sent, awaiting response... 302 Found
Location: https://raw.githubusercontent.com/microsoft/WhatTheHack/blob/master/020-LinuxFundamentals/Student/resources/simple-php-app.tar.gz [following]
--2022-11-09 01:46:30--  https://raw.githubusercontent.com/microsoft/WhatTheHack/blob/master/020-LinuxFundamentals/Student/resources/simple-php-app.tar.gz
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.108.133, 185.199.110.133, 185.199.111.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 28596 (28K) [application/octet-stream]
Saving to: ‘simple-php-app.tar.gz’

simple-php-app.tar.gz         100%[=================================================>]  27.93K  --.-KB/s    in 0.001s

2022-11-09 01:46:30 (32.0 MB/s) - ‘simple-php-app.tar.gz’ saved [28596/28596]
```

2. Create the Dockerfile

In your home directory create a file called Dockerfile with the following content:

```bash
FROM debian
MAINTAINER You - you@domain.com

# Packages
RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y php7.4-fpm

# Nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN rm /etc/nginx/sites-available/default
ADD ./default /etc/nginx/sites-available/default

# Build
RUN mkdir -p /var/www/app
WORKDIR /var/www/app
ADD simple-php-app.tar.gz /var/www/app/
RUN mv simple-php-app/* /var/www/app

EXPOSE 80
CMD service php7.4-fpm start && nginx -g "daemon off;"

EXPOSE 80 
CMD service php7.4-fpm start && nginx -g "daemon off;" 
```

3. Create the Nginx config file which will be addedd to the container. Create a file called "default" with the following content

```bash
server {
    listen   80;
    root /var/www/app;
    index index.php index.html;
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
} 
```

4. Now let's build the image

`student@vm01:~$ sudo docker build . -t simplephpapp`

```bash
Sending build context to Docker daemon  65.02kB
Step 1/18 : FROM debian
latest: Pulling from library/debian
Digest: sha256:bfe6615d017d1eebe19f349669de58cda36c668ef916e618be78071513c690e5
Status: Downloaded newer image for debian:latest
 ---> d8cacd17cfdc
Step 2/18 : MAINTAINER You - you@domain.com
 ---> Using cache
 ---> 83acf6cf1f2d
Step 3/18 : RUN apt-get update
 ---> Using cache
 ---> b929078269b7
Step 4/18 : RUN apt-get install -y nginx
 ---> Using cache
 ---> 68063a951ff4
Step 5/18 : RUN apt-get install -y php7.4-fpm
 ---> Using cache
 ---> 0cb1d630711e
Step 6/18 : RUN apt-get install -y git
 ---> Using cache
 ---> 435a4829076e
Step 7/18 : RUN ln -sf /dev/stdout /var/log/nginx/access.log
 ---> Using cache
 ---> 31d6e194d730
Step 8/18 : RUN ln -sf /dev/stderr /var/log/nginx/error.log
 ---> Using cache
 ---> 6f65a0b879af
Step 9/18 : RUN rm /etc/nginx/sites-available/default
 ---> Using cache
 ---> 7e04479f1d86
Step 10/18 : ADD ./default /etc/nginx/sites-available/default
 ---> Using cache
 ---> 5fee93e719d7
Step 11/18 : RUN mkdir -p /var/www/app
 ---> Using cache
 ---> 784c3f6896e4
Step 12/18 : WORKDIR /var/www/app
 ---> Using cache
 ---> 9f805984b671
Step 13/18 : ADD simple-php-app.tar.gz /var/www/app/
 ---> Using cache
 ---> 5bff0a480b9a
Step 14/18 : RUN mv simple-php-app/* /var/www/app
 ---> Using cache
 ---> 3655c1b7cb7d
Step 15/18 : EXPOSE 80
 ---> Using cache
 ---> 511c32e0a94b
Step 16/18 : CMD service php7.4-fpm start && nginx -g "daemon off;"
 ---> Using cache
 ---> 055051250d25
Step 17/18 : EXPOSE 80
 ---> Running in fb829564dede
Removing intermediate container fb829564dede
 ---> 43377c41d083
Step 18/18 : CMD service php7.4-fpm start && nginx -g "daemon off;"
 ---> Running in ee37edab8670
Removing intermediate container ee37edab8670
 ---> 29df1bb28150
Successfully built 29df1bb28150
Successfully tagged simplephpapp:latest
```

5. Let's run our container mapping the container port 80 to the 8080 on the virtual machine


`student@vm01:~$ sudo docker run -d -p 8080:80 simplephpapp`

```bash
cf07d004cddde38366fe49af702dc9ad99099fbae6735460e2432eeef6db8607
```

6. Let's test


`student@vm01:~$ curl localhost:8080`

```bash
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>Simple PHP App</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="assets/css/bootstrap.min.css" rel="stylesheet">
        <style>body {margin-top: 40px; background-color: #333;}</style>
        <link href="assets/css/bootstrap-responsive.min.css" rel="stylesheet">
        <!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
    </head>

    <body>
        <div class="container">
            <div class="hero-unit">
                <h1>Simple PHP App</h1>
                <h2>Congratulations!</h2>
                <p>Your PHP application is now running on the host <strong>&ldquo;6f93282d4760&rdquo;</strong></p>
                <p>This host is running PHP version <strong>7.4.30.</strong></p>
                <p>Powered by Microsoft Azure!</p>
            </div>
        </div>

        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
    </body>

</html>
```

7. Publish the image to Docker Hub

Now if you want to share this application with the world, you can publish it to the Docker Hub. Go to https://hub.docker.com and create your free account. 

Then let's create a tag for our image before publish on Docker Hub

`student@vm01:~$ sudo docker tag simplephpapp <username>/simplephpapp`

Log-in into your Docker account:

`student@vm01:~$ sudo docker login`

```bash
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <username>
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded
```
Upload your image to Docker Hub:

`student@vm01:~$ sudo docker push username/simplephpapp`

```bash
Using default tag: latest
The push refers to repository [docker.io/username/simplephpapp]
2d37541b2339: Pushed
344414308e52: Pushed
9a637731d024: Pushed
fca49c737601: Pushed
34141b7e27dc: Pushed
c0d2c2ffac17: Pushed
c3546dcce943: Pushed
b2a882794e1a: Pushed
3af4c408a1f6: Pushed
77c055de0507: Pushed
d80da1ca62ca: Pushed
d9d07d703dd5: Mounted from library/debian
latest: digest: sha256:4b2ca1bd723bbebcf9ca955e35bf47f1b461b53cb1d0ef835dcb91367068416a size: 2830
```

And if you would like to connect to your container in execution and check internally, you can run the following command:

`student@vm01:~$ sudo docker run -t -i simplephpapp /bin/bash`

```bash
root@ac4a7ec02110:/var/www/app#
```

