#!/bin/bash
apt-get -y update

# install Apache2
apt-get -y install apache2 

# write some HTML
echo \<center\>\<h1\>Wecome to What The Hack: IaC ARM Template Challenges\</h1\>\<br/\>\</center\> > /var/www/html/wth.html

# restart Apache
apachectl restart