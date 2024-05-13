# Challenge 00 - Pre-Requisites - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Students may wish to use Visual Studio Code on their local workstation with Codespaces since it is a bit nicer than working in the browser. They can click the Codespaces area in the local left corner and select Open in VS Code Desktop to do that. Alternatively, they can install the Codespaces App in the browser which will give them a focused window as well as other features.

Students should avoid doing the local workstation setup because there is the potential to adversely affect their local workstation (especially if they accidentally change the default Python version on their computer on Linux/Mac). There can be a lot of variations in terms of the student's OS version, already installed software packages like Python, Node, etc. that may cause them to lose time trying to get their environment working. However, the only way to get debugging working in Python in the Azure Functions Runtime is to do it locally. We don't expect most students to need debugging but some more advanced students may want it to see how the code is working. 

Unfortunately, debugging will not work in Codespaces because Codespaces runs as a container and the ability to attach to another Python process requires a special kernel flag to be set in Linux:
`echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope`

Warning: Changing this setting makes the local workstation less secure and should not be changed permanently. 

More information on setting up local debugging for Python is available here: https://code.visualstudio.com/docs/python/debugging

