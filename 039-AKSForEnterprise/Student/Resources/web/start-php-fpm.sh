#!/bin/bash
env | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" > /etc/conf.d/env.conf
/usr/sbin/php-fpm -D