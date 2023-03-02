# Modern development and DevOps with GitHub: Add a feature to the existing application

[< Previous](challenge01.md) - [Home](../readme.md) - [Next >](challenge03.md)

## Scenario

The shelter's board knows there's a lot of work to be done on the application. Because they're trying to get things moving in the right direction, they want to make one quick change to ensure their DevOps processes work correctly. To do this, the board would like to display the hours the shelter is open for the current day. The shelter is open from 10am to 4pm Monday-Friday, and 9am to 8pm Saturday and Sunday. They'd like to have this as a new React component in the project so it can be used in different places in the application.

## Challenge

With the development environment created and configured, it's time for some development. While the project uses [Next.js](https://nextjs.org)/[React](https://reactjs.org), not everyone is an expert in those frameworks. Even experts can struggle at times to remember syntax. And no developer likes enjoys the tedious tasks which often arise when writing code. [GitHub Copilot](https://github.com/features/copilot) is an AI pair programmer trained on billions of lines of publicly available code and text, designed to offer code suggestions to enhance and streamline your development process.

> **IMPORTANT:** As highlighted earlier, coding experience is **not** required for this hack. This challenge can be skipped, or you can use the [solution mentioned in development notes](#development-notes).

For this challenge, you will create a new React component named **Hours.js** in the **components** folder. You will add the code necessary to display the hours for the current day of the week. After creating the component, you will update **index.js** in the **pages** folder to import the newly created component and display it on the page.

> **IMPORTANT:** Do **not** commit the files to the `main` branch. In an upcoming challenge you will create a pull request.

## Challenge notes

- Create the `Hours` component by adding a file named **Hours.js** to the **components** folder.
- A potential solution for the Hours component is available from your coach.
- The syntax to import the `Hours` component in **index.js** is `import Hours from '../components/Hours';`, and can be placed below the line which reads `// TODO: Import Hours component`.
- The syntax to display the `Hours` component in **index.js** is `<Hours />`, and can be added immediately below the line which reads `{/* TODO: Display Hours component */}`.
- For purposes of this challenge, you can read the current day from the browser without regard for the user's timezone.

## Hints

- All React components need to `import React from 'react';` at the top of the file.
- GitHub Copilot offers suggestions based on both code and comments. You can describe in natural language the task you are trying to accomplish and Copilot will offer suggestions.
- Rewording comments can help Copilot offer different suggestions closer to what you are looking for.

### Success Criteria

- You have created a new component named `Hours` which displays the hours for the current day.
- The `Hours` component is called in **index.js**.
- The hours are successfully displayed on the site.

### Learning Resources

- [Getting started with React](https://reactjs.org/docs/hello-world.html)
- [Getting started with GitHub Copilot in Visual Studio Code (Codespaces)](https://docs.github.com/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-visual-studio-code)
- [Getting your first suggestion with GitHub Copilot](https://docs.github.com/copilot/quickstart#getting-your-first-suggestion) 

[< Previous](challenge01.md) - [Home](../readme.md) - [Next >](challenge03.md)
