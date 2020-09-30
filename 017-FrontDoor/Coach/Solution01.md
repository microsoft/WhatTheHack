# Notes for Challenge 1 - Setup your Environment and Discover

 **[Home](./README.md)** - [Next Challenge [2] >](./Solution02.md)

Hopefully most students started the prerequisites.  If a student doesn't have some Linux instance configured, installing WSL during a Hack could be all day.  Either that person should pair up (if possible given Virtual delivery) or go write to Create a Linux VM.  This process has been done on Ubuntu 18.04.  

The documentation is pretty good about for [Install w3af](http://docs.w3af.org/en/latest/install.html).  The installation process is basically self-correcting, generating a bash script to run.  This can involve many iterations of trying to run w3af_console, then run install script.  **Only use the w3af_console, the GUI option might be attractive to people.  All the commands are given so people are just investing time to install it.**

If you have a large group of people from the organization or its a larger event, its recommended for the Sitename, to give everyone a prefix or even preassign Sitenames with a prefix and then team number (using the 13 characters).  This will be used to create a public DNS subdomain that is used for everything.  Pay close attention to the restrictions on the name:
      1. Up to 13 characters long
      2. Must start with a lower case letter
      3. Next up to 12 characters can be either
         1. lower case character
         2. number
         3. dash '-'

The only other advise is that there are a lot of folks that have never opened up the Dev Tools for a Browser, much less analyzed the way a website loads.  The key items we want to point out:
- Everything is sourced from the same DNS Name, which means every requests for CSS/JS/Images/etc..  hit the website.  (very bad)
- Nothing is cached, every reload does a full reload (with response code of 200's)
- Getting them to see the Waterfall, that shows the break down of the request when you hover over the Waterfall display on each row in the Network tab ![alt](./images/Waterfall.png)
