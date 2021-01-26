# How to use deploy.ps1 to publish your bot to azure

Ensure you have installed necessary dependencies:
* azure cli (latest version)
* dotnet core (version >= 3.0)
* powershell (version >= 6.0)
* bf command (npm i -g @microsoft/botframework-cli@next)
* bf plugins (bf plugins:install @microsoft/bf-sampler-cli@beta)

Then please refer to the following steps:

1. Eject your own C# runtime in composer
2. Navigate to your runtime azurewebapp folder, for example C:\user\test\ToDoBot\runtime\azurewebapp
3. Execute this command under azurewebapp folder:
    ```
    \Scripts\deploy.ps1 -name <name of resource group> -hostName <hostname of azure webapp> -luisAuthoringKey <luis authoring key> -qnaSubscriptionKey <qna subscription key> -environment <environment >
    ```

4. Or if you have saved your publishing profile to json format (profile.json), you can execute:

    ```
    \Scripts\deploy.ps1 -publishProfilePath < path to your publishing profile>
    ```


parameters of deploy.ps1:

| Param        |            |
| ------------- |:-------------:|
| name      | name of your Bot Channels Registration|
| environment      | environment, same as composer      |
| hostName | hostname of your azure webapp instance      |
| luisAuthoringKey | luis authoring key, only needed in luis|
| luisAuthoringRegion | luis authoring region, could be optional|
| qnaSubscriptionKey | qna subscription key, only needed in qna feature|
| language | language of yoru qna & luis, defaults to 'en-us' |
| botPath | path to your bot assests, defaults to ../../ for ejected runtime |
| logFile | path to save your log file, deafults to deploy_log.txt |
| runtimeIdentifier | runtime identifier of your C# publishing targets, defaults to win-x64, please refer to this doc: https://docs.microsoft.com/en-us/dotnet/core/rid-catalog|
| luisResource | the name of your luis prediction (not authoring) resource |
| publishProfilePath | the path to your publishing profile (json formate) |