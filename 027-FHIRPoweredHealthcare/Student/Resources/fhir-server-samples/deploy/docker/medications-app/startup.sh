#!/bin/bash

sed -i "s/my_web_app/${CLIENT_ID}/" launch.html
npm start