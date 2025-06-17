#!/bin/sh
 
# Log some info we might need to troubleshoot.
ls /workspaces > ~/postAttachCommands.log
env >> ~/postAttachCommands.log
 
# Retrieve the Codespace name if not already set.
if [ -z "$CODESPACE_NAME" ]; then
    CODESPACE_NAME=$(gh codespace list --json name --jq '.[0].name')
fi
 
# Change the backend and frontend port visibility to public...
gh codespace ports -c $CODESPACE_NAME >> ~/postAttachCommands.log
gh codespace ports visibility 7072:public -c $CODESPACE_NAME
gh codespace ports visibility 4200:public -c $CODESPACE_NAME
gh codespace ports -c $CODESPACE_NAME >> ~/postAttachCommands.log
 
# Update the backend URL in the environment.ts file.
BACKEND_ADDRESS=$(gh codespace ports -c $CODESPACE_NAME --json label,browseUrl | jq -r '.[] | select(.label == "backend").browseUrl')
sed -i 's|http://localhost:7072|'$BACKEND_ADDRESS'|g' $CODESPACE_VSCODE_FOLDER/ContosoAIAppsFrontend/src/environments/environment.ts
 
# Update the frontend URL in the environment.ts file (if needed).
FRONTEND_ADDRESS=$(gh codespace ports -c $CODESPACE_NAME --json label,browseUrl | jq -r '.[] | select(.label == "frontend").browseUrl')
sed -i 's|http://localhost:4200|'$FRONTEND_ADDRESS'|g' $CODESPACE_VSCODE_FOLDER/ContosoAIAppsFrontend/src/environments/environment.ts

