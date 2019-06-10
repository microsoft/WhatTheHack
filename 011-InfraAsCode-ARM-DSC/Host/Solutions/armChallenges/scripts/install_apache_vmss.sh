#!/bin/bash


# install Apache (in a loop because a lot of installs happen
# on VM init, so won't be able to grab the dpkg lock immediately)
until apt-get -y update && apt-get -y install apache2
do
  echo "Try again"
  sleep 2
done

# write some HTML
echo \<center\>\<h1\>Wecome to P20 ARM Training\</h1\>\<br/\>\</center\> > /var/www/html/p20.html

# restart Apache
apachectl restart