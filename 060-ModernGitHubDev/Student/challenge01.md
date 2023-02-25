# Modern development and DevOps with GitHub: Configure your development environment

[< Previous](challenge00.md) - [Home](../readme.md) - [Next >](challenge02.md)

## Scenario

With a copy of the project obtained, it's time to turn your attention to setting up your development environment. The shelter's board is keen on ensuring developers are able to contribute to the project as seamlessly as possible, avoiding tedious setup. To meet this requirement, setting up the project on a developer's box isn't the best option. You will want to find a cloud based solution which allows for a centrally configured development environment.

## Challenge

You will create a development environment which meets the needs listed above. You want to be able to begin writing code without having to install any resources locally on your machine.

During the development process, you will be creating various Azure resources and configuring your GitHub repository. As a result, you'll need to have access to the [Azure CLI](https://learn.microsoft.com/cli/azure/) and [GitHub CLI](https://learn.microsoft.com/cli/azure/).

The application uses an environment variable named `MONBODB_URI` to connect to the MongoDB database. When creating the cloud-based development environment, you will need to add this as an encrypted secret with the value **mongodb://localhost**.

Once the development environment is created, you will need to test the application by running the following commands:

```bash
npm install
npm run dev
```

## Success criteria

- You have created and configured a cloud-based development environment with the following resources installed:
  - GitHub CLI
  - Azure CLI
  - MongoDB
- You have created an encrypted secret for `MONGODB_URI`
- You are able to launch and view the application in the cloud-based development environment
- All changes are merged into `main`
- **No** resources were installed on your machine

## Hints

- **Ctl-\`** will display the terminal window in Codespaces
- **Cmd-Shift-P** (Mac) or **Ctl-Shift-P** (PC) will open the command pallette

## Learning Resources

- [GitHub Codespaces](https://docs.github.com/codespaces/overview)
- [Introduction to dev containers](https://docs.github.com/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
- [Setting up a Node.js project](https://docs.github.com/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-nodejs-project-for-codespaces)
- [Adding features to a devcontainer.json file](https://docs.github.com/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file)
- [Forwarding ports in your codespace](https://docs.github.com/codespaces/developing-in-codespaces/forwarding-ports-in-your-codespace)
- [Managing encrypted secrets for your codespaces](https://docs.github.com/codespaces/managing-your-codespaces/managing-encrypted-secrets-for-your-codespaces)
- [Developing in a codespace](https://docs.github.com/codespaces/developing-in-codespaces/developing-in-a-codespace)
- [Prebuilding your codespaces](https://docs.github.com/codespaces/prebuilding-your-codespaces)

[< Previous](challenge00.md) - [Home](../readme.md) - [Next >](challenge02.md)
