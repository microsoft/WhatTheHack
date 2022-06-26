FROM centos:latest
MAINTAINER Jose Moreno <jose.moreno@microsoft.com>

# CentOS Linux 8 had reached the End Of Life (EOL) on December 31st, 2021.
# It means that CentOS 8 will no longer receive development resources from the official CentOS project.
# After Dec 31st, 2021, if you need to update your CentOS, you need to change the mirrors to
# vault.centos.org where they will be archived permanently. Alternatively, you may want to upgrade to CentOS Stream.
# Reference: https://techglimpse.com/failed-metadata-repo-appstream-centos-8/
# Another alternative is running a different distro such as rocketlinux:latest

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN yum update -y
RUN yum install -y httpd
RUN yum install -y php php-fpm php-json php-devel curl wget

# Create dir for php-fpm
RUN mkdir /run/php-fpm

# Redirect httpd logs to stdout
RUN ln -sf /proc/self/fd/1 /var/log/httpd/access_log && ln -sf /proc/self/fd/1 /var/log/httpd/error_log

# To expose env variables to php
RUN sed -i "s|;*clear_env\s*=\s*yes|clear_env = no|g" /etc/php-fpm.d/www.conf
RUN sed -i "s|;*clear_env\s*=\s*no|clear_env = no|g" /etc/php-fpm.d/www.conf

# Expose apache.
EXPOSE 80

# Copy PHP page and delete index.html
COPY index.php /var/www/html/index.php
COPY info.php /var/www/html/info.php
COPY styles.css /var/www/html/styles.css
COPY favicon.ico /var/www/html/favicon.ico

# Create healthcheck pages
RUN echo '{"health": "OK"}' >/var/www/html/healthcheck.html
RUN echo "<?php phpinfo() ?>" > /var/www/html/healthcheck.php

# By default start up apache in the foreground, override with /bin/bash for interactive.
CMD /usr/sbin/php-fpm -D; /usr/sbin/httpd -D FOREGROUND
