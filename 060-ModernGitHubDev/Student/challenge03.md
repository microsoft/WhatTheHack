# Modern development and DevOps with GitHub: Continuous integration and security

[< Previous](challenge02.md) - [Home](../readme.md) - [Next >](challenge04.md)

## Scenario

The board of the shelter has seen many troubling news stories of breeches into various applications, including those run by non-profits. In fact, organizations which traditionally may not have invested in infrastructure can be popular targets for attackers. The board wants to ensure their application doesn't contain any vulnerabilities which can be exploited.

## Challenge

For this challenge you will configure scanning for the entire [software supply chain](https://github.blog/2020-09-02-secure-your-software-supply-chain-and-protect-against-supply-chain-threats-github-blog/) for the application. Specifically, you want to scan your code for potential issues when a [pull request (PR)](https://docs.github.com/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) is made to the `main` branch. You also want to confirm the packages the project uses are free from known vulnerabilities. Finally, once you have configured security, you will create a pull request with the code updates you made in the previous challenge.

Scanning for vulnerabilities, running tests, and ensuring code compiles is typically automated as part of a process called **continuous integration** (CI). CI allows teams to quickly validate new code doesn't introduce any issues to the existing code base, improving your ability to respond to customer requests and reduce development overhead. For this hack, you will enable [GitHub Advanced Security](https://docs.github.com/get-started/learning-about-github/about-github-advanced-security), which is a common part of a complete CI process.

## Success criteria

- [Code scanning](https://docs.github.com/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning) is set to run on all pull requests made to `main`
- [Dependency review](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review) is enabled for the repository
- The `main` branch is configured to require pull requests, and both code scanning and dependency review must succeed for a merge to be completed
- A pull request has been made to main and all checks pass

> **IMPORTANT:** You will merge the PR into `main` in a later challenge

## Learning resources

- [Introduction to GitHub Actions](https://docs.github.com/actions/learn-github-actions/understanding-github-actions)
- [About code scanning](https://docs.github.com/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning)
- [Configuring code scanning for a repository](https://docs.github.com/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning-for-a-repository)
- [About dependency review](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review)
- [Configure dependency review](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/configuring-dependency-review)
- [About protected branches](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [About branch protection rules](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)
- [Using source control in your codespace](https://docs.github.com/codespaces/developing-in-codespaces/using-source-control-in-your-codespace)

[< Previous](challenge02.md) - [Home](../readme.md) - [Next >](challenge04.md)
