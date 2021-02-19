# Challenge 7 - Build a CI/CD workflow with GitHub actions

[< Previous Challenge](06-AddApplicationMonitoring.md) - **[Home](README.md)** - [Next Challenge >]()

## Prerequisites

1. [Challenge 6](06-AddApplicationMonitoring.md)

## Setup repository secrets

1. Setup repository secrets that are needed for the workflow to succeed

    ```bash
    # GitHub Personal Access Token with Repo access
    WTH_CR_PAT = PAT char string

    # Download your app's publish profile from the Azure Portal
    WTH_WEBAPP_SITECRED = publish profile content
    ```

## CI: Create a new Github workflow to build the docker image

1. If this is the firs time creating a workflow, click on *setup a workflow yourself*
2. In the editor, delete any steps after `- uses: actions/checkout@v2`
3. Now add actions to setup your docker environment, build and push your images to your private repo

    ```yaml
    # Setup output job variables, and job environment. 
    outputs:
      image: ${{ steps.image-name.outputs.image }}

    env:
      registry: '<REGISTRY-SERVER>'
      ghOrgName: '<GITHUB-ORG-NAME>'
      basePath: 'Student/Resources'
      imageName: 'rockpaperscisors-server'
      imageDockerFile: 'Dockerfile-Server'

    steps:
    - uses: actions/checkout@v2
  
   # Action to create a unique tag for the image
    - name: Image Tag
      id: image-tag
      run: |
        echo "::set-output name=tag::$(date +%s)"

    # Sets up docker build system
    - name: Docker Setup Buildx
      uses: docker/setup-buildx-action@v1.1.1
    
    # Configures docker to use your private registry  
    - name: Docker Login
      uses: docker/login-action@v1.8.0
      with:
        username: ${{ env.ghOrgName }}
        password: ${{ secrets.WTH_CR_PAT }}
        registry: ${{ env.registry }}
      
    # Builds and pushes the image
    - name: Build and push image
      uses: docker/build-push-action@v2.2.1
      with:
        context: ${{ env.basePath }}/Code
        file: ${{ env.basePath }}/Code/${{ env.imageDockerFile }}
        push: true
        tags: ${{ env.registry }}/${{ env.ghOrgName }}/${{ env.imageName }}:${{ steps.image-tag.outputs.tag }}

    # We capture the image name and tag in an output variable so we know which one to use for deployment
    - name: Set Image to Deploy
      id: image-name
      run: |
        echo "::set-output name=image::${{ env.imageName }}:${{ steps.image-tag.outputs.tag }}"
   ```

4. Commit the workflow to trigger the workflow and build the first image
5. Look at your registry and validate the image is listed

## CD: Modify your Github workflow deploy the app

1. Edit the previous workflow and add a separate job to deploy the image to Azure App Service

    ```yaml
    Deploy-Image:

        runs-on: ubuntu-latest
        needs: [Build-Image]
        env:
          imageName: ${{ needs.Build-Image.outputs.image }}     #This is the output variable from the build job
          webApp: '<WEB-APP-NAME>'
          registry: '<REGISTRY-SERVER>'
          ghOrgName: '<GITHUB-ORG-NAME>'

        steps:
        - name: Azure WebApp
            uses: Azure/webapps-deploy@v2
            with:
            app-name: ${{ env.webApp }} 
            publish-profile: ${{ secrets.WTH_WEBAPP_SITECRED }}
            images: ${{ env.registry }}/${{ env.ghOrgName }}/${{ env.imageName }}
    ```

2. Commit the changes to trigger the workflow and deploy your app
3. Visit the website to validate it's working