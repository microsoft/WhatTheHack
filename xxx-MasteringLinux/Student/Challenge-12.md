# Challenge 12 - Setting up a webserver 

[< Previous Challenge](./Challenge-11.md) - **[Home](../README.md)** 

## Description

In this challenge we will setting up a webserver and deploy a simple php application into it. As a plus, you can add SSL to ensure security requirements.

- Download the sample application [from here](./resources/simple-php-app.tar.gz) to your home directory
- Extract the content of simple-php-app.tar.gz on our home directory
- Install nginx-core
- Install php7.4-fpm
- Configure Nginx

## Success Criteria

1. Make sure you have the file simple-php-app-tar.gz within your `~`
2. Show the content of the .tar.gz file extracted into your `~`
3. Make sure you have the packages nginx-core and php7.4-fpm installed
4. Show your Nginx running properly

## Hint

If you install Ubuntu 18.04 instead of the Ubuntu 20.04, the version of the php-fpm which will be installed will be the 7.2 instead of 7.4. Then make sure to configure the nginx config file properly.

## Learning Resources

- [https://www.rosehosting.com/blog/how-to-install-php-7-4-with-nginx-on-ubuntu-20-04/](https://www.rosehosting.com/blog/how-to-install-php-7-4-with-nginx-on-ubuntu-20-04/)
- [https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-20-04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-20-04)

## Advanced Challenge
*Too comfortable?  Eager to do more?  Try this additional challenge!*

- Add SSL
_Please note that for this advanced challenge, you will need to be able to access the virtual machine using a Public IP due the usage of an SSL certificate._




