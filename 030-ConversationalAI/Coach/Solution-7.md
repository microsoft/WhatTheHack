# Challenge 7: CI/CD
[< Previous Solution](./Solution-6.md) - **[Home](./Readme.md)** 
## Notes & Guidance
1. Bot composer doesn't provide built in CI/CD integration. [issue1](https://github.com/microsoft/BotFramework-Composer/issues/3339) , [issue2](https://github.com/microsoft/BotFramework-Composer/issues/5581)
2. In order to setup CI/CD first we need to export the underline code from the bot composer. [Ref](https://docs.microsoft.com/en-us/composer/how-to-add-custom-action#export-runtime)
3. Use azurewebapp instead of azurefunctions
4. Unit tests generated for the azurewebapp won't work so don't use it to run unit tests in the CI Pipeline
5. For CD, we can leverage the deployment artifacts provided by the bot composer but it still needs some hacking to work. [ref](https://github.com/microsoft/BotFramework-Composer/tree/main/runtime/dotnet/azurewebapp/Scripts)
6. At a high-level, below is a real world workflow look like

    ![alt text](https://user-images.githubusercontent.com/11544153/105419544-e36f0980-5c0c-11eb-9573-43316c6cf505.png)
        


