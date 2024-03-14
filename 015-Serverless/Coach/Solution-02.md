# Challenge 02 - Create a Hello World Function - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

- Some Windows users may get an execution policy error when running in a powershell terminal.  They can run `Get-ExecutionPolicy` to determine if they are restricted.  They can run [`Set-ExecutionPolicy`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7) with the desired scope.
- Depending on which language is chosen by the student, there may be extra installations required. C# or Javascript are strongly recommended
- Check for supported version language [versions](https://docs.microsoft.com/en-us/azure/azure-functions/supported-languages)
- If a student tries the Azure Functions CLI, i.e. "func new", some things may break. Looks like if you run "func new" in the TollBooth project, it prompts you to "--force". When you do that, it messes with the libraries (updates the versions) and sends you down a spiral of "code doesn't build anymore" because of backward compatibility issues. We might recommend if students run in to this to "git  reset --hard" then run func new from a new folder.

- You can not create a cognitive service via CLI if you have not created at least one via the portal and agreed to the responsible AI terms
```
(ResourceKindRequireAcceptTerms) This subscription cannot create ComputerVision until you agree to Responsible AI terms for this resource. You can agree to Responsible AI terms by creating a resource through the Azure Portal then trying again. For more detail go to https://go.microsoft.com/fwlink/?linkid=2164911
Code: ResourceKindRequireAcceptTerms
``` 

- If using Codespaces, in order to work with a folder containing a function written in a different language, we must click the "burger" menu on the top left, then Open Folder in New Window, and select the folder with the function. This is because the VS Code extension for Azure Functions assumes the Local Workspace Project to contain functions of the same single language. This may be worked around using [Multi-root workspaces](https://github.com/microsoft/vscode-azurefunctions/wiki/Multiple-function-projects) , but it hasn't been tested in Codespaces with Azure functions 

## Step by Step Instructions
Students are expected to follow this Quickstart: 
- [RECOMMENDED: Visual Studio Code](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp)
- [Visual Studio](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-your-first-function-visual-studio)

