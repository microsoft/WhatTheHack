# Challenge 00 - Pre-Requisites - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

### Codespaces vs Local Workstation

We **strongly** recommend students use GitHub Codespaces as their development environment over a local workstation.

Students should avoid doing the local workstation setup because there is the potential to adversely affect their local workstation (especially if they accidentally change the default Python version on Linux/Mac/WSL). There can be a lot of variations in terms of the student's OS version, already installed software packages like Python, Node, etc. that may cause them to lose time trying to get their environment working. However, the only way to get debugging working in Python in the Azure Functions Runtime is to do it locally. We don't expect most students to need debugging but some more advanced students may want it to see how the code is working. 

#### Debugging Python on Local Workstation

Debugging Python on a local workstation requires the ability to attach to another Python process which requires a special kernel flag to be set in Linux environment and this can only be done on the host:
`echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope`

>[!WARNING]
>Changing the above setting makes the local workstation less secure and should not be changed permanently. 

Debugging is not required to complete the challenges, but students may attempt to configure and run a debugger while troubleshooting. Coaches should be aware of this issue and point students to the following guide on setting up local debugging for Python: [Python Debugging in VS Code](https://code.visualstudio.com/docs/python/debugging)

To debug on a local workstation, students will also need `gdb` (`sudo apt install gdb`) which is not mentioned in the above article. 

### GitHub Codespaces Tips

#### Working with Multiple Terminal Sessions in VS Code/Codespace

During this hack, students will need to have multiple Terminal sessions open to keep the sample application's Frontend and Backend running while they hack.  If students are not familiar with how to manage multiple Terminal sessions in the VS Code interface within Codespace, you may want to demonstrate this to them.

Students can create additional Terminal sessions by clicking the `+` icon in the lower right side of the VS Code window. They can then switch between Terminal sessions by clicking the session name in the session list below the `+` icon as per the screenshot below.

Terminal sessions can be renamed by right-clicking on the session. Students may wish to rename the Frontend and Backend sessions so they can keep track of where they started the application components.

![Manage Multiple Terminals in VS Code](../images/manage-multiple-terminal-sessions-vscode.png)

#### Run Codespace in VS Code on Local Workstation

Students may wish to use Visual Studio Code on their local workstation with Codespaces since it is a bit nicer than working in the browser. This makes it easier to keep track of the Codespace in a VS Code window versus having it get lost amongst many browser tabs. 

To do this, students can click the Codespaces area in the lower left corner of the Codespace browswer tab and select `Open in VS Code Desktop` as shown in screenshot below:

![screenshot of how to open Codespace in VS Code](../images/open-codespace-in-vscode.png)

Alternatively, they can install the Codespaces App in the browser which will give them a focused window as well as other features.

#### Python Debugging Not Available in Codespaces

Unfortunately, debugging will not work in Codespaces because Codespaces runs as a container and the ability to attach to another Python process requires a special kernel flag to be set in Linux and this can only be done on the local OS.

Debugging is not required to complete the challenges, but students may attempt to run a debugger while troubleshooting. You should be aware of this issue as a Coach so students don't spend time trying to figure this out in Codespaces.
