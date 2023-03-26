# Challenge 02 - Installing the emulator - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

The student will need to:
- clone the
[Microsoft Commercial Marketplace API Emulator](https://github.com/microsoft/Commercial-Marketplace-SaaS-API-Emulator)
- open the emulator in a new insatnce of VS Code - they will need for a later challenge

Options to run the emulator as a:
- Node App
  - From Bash or in the VS Code termainl navigate to the project folder
  - `NPM Install` to install the Node required modules
  - To run, either:
    - in Bash, `NPM Run` 
    - Debug in VS Code, **F5** or select **Run and Debug** tab on the left bar and click **Launch** - if Lunch is not available it is likely NPM Install was skipped
- Container
  - From the Terminal - in the project folder
    - `docker build -t marketplace-api-emulator -f docker/Dockerfile .`
    - `docker run -d -p <port>:80 marketplace-api-emulator`
  - In VS Code, when running as a Dev Container
    - Run the debugger as described above

The emulator will now be available in a browser on `http://localhost:<port>`

The port should be shown in the terminal at launch, by deault this would be port **3978** for Node, **80** for a continer.
