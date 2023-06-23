#!/bin/bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

declare -r templateDirectoryName="000-HowToHack"
declare -r openAIPromptDirectoryName="openai-prompts"

Help() {
   echo "Syntax: createWthTemplate [-c|r|h|n|p|d|k|e|a|v]"
   echo "options:"
   echo "c     How many challenges to stub out."
   echo "r     Remove existing directory with same name."
   echo "h     Print this Help."
   echo "n     Name of the new WhatTheHack. This must be a valid directory name"
   echo "p     Path to where to create new WhatTheHack directory."
   echo "d     Description of the hack."
   echo "k     Key words for the hack."
   echo "e     Endpoint for the OpenAI service (including api-version query parameter)."
   echo "a     OpenAI API key."
   echo "v     Verbose mode."
   echo
}

GetOpenAIPromptContent() {
  local -r pathToPromptFile=$1

  local -r promptText=$(cat $pathToPromptFile)

  echo "$promptText"
}

GenerateOpenAIMessageArray() {
  local -r systemContent=$1
  local -r userPromptContent=$2
  
  read -r -d '' messageArray << EOF
[
  { 
    "role": "system", 
    "content": "$systemContent" 
  }, 
  { 
    "role": "user", 
    "content": "$userPromptContent" 
  }
]
EOF

  echo "$messageArray"
}

CallOpenAI() {
  local -r messageArray=$1

  local -r openAIResponse=$(curl $openAIEndpointUri \
    --header "Content-Type: application/json" \
    --header "api-key: $openAIApiKey" \
    --silent \
    --show-error \
    --data @- << EOF
{ 
  "messages": $messageArray, 
  "max_tokens": 800, 
  "temperature": 0.7, 
  "top_p": 0.95, 
  "frequency_penalty": 0, 
  "presence_penalty": 0, 
  "stop": null 
}
EOF
)

  echo $openAIResponse | yq '.choices[].message.content'
}

CreateDirectoryStructure() {
  local -r deleteExistingDirectory=$1

  if $deleteExistingDirectory; then
    rm -rf $rootPath
  fi

  if $verbosityArg; then
    echo "Creating $rootPath directory..."
  fi

  # create the xxx-YetAnotherWth directory
  mkdir $rootPath

  if $verbosityArg; then
    echo "Creating $rootPath/Coach/Solutions directories..."
  fi

  # create the Coach & Coach/Solutions directories
  mkdir -p $rootPath/Coach/Solutions

  #add a file to allow git to store an "empty" directory
  touch $rootPath/Coach/Solutions/.gitkeep

  # copying the Coach Lectures template file in the /Coach directory
  cp $templateDirectoryName/WTH-Lectures-Template.pptx $rootPath/Coach/Lectures.pptx

  if $verbosityArg; then
    echo "Creating $rootPath/Student/Resources directories..."
  fi

  # create the Student & Student/Resources directories
  mkdir -p $rootPath/Student/Resources
  
  #add a file to allow git to store an "empty" directory
  touch $rootPath/Student/Resources/.gitkeep
}

WriteMarkdownFile() {
  local -r pathToPromptFile=$1
  local -r openAIUserPrompt=$2
  local -r pathToMarkdownFile=$3

  local -r openAISystemPrompt=$(GetOpenAIPromptContent "$pathToPromptFile")

  local -r messageArray=$(GenerateOpenAIMessageArray "$openAISystemPrompt" "$openAIUserPrompt")

  local -r openAIResponse=$(CallOpenAI "$messageArray")

  cat > "$pathToMarkdownFile" <<< $openAIResponse

  echo "$openAIResponse"
}

CreateHackDescription() {
  local -r numberOfChallenges=$1

  local -r openAIResponse=$(WriteMarkdownFile "$pathToOpenAIPromptDirectory/WTH-How-To-Author-A-Hack-Prompt.txt" \
    "Generate a overview page of the hack based upon the following description: $descriptionOfHack. Generate $numberOfChallenges challenges. Use the following keywords to help guide which challenges to generate: $keywords" \
    "$rootPath/README.md")

  echo "$openAIResponse"
}

CreateChallengeMarkdownFile() {
  local -r fullPath=$1
  local -r prefix=$2
  local -r suffixNumber=$3
  local -r numberOfChallenges=$4

  local -r openAIResponse=$(WriteMarkdownFile "$pathToOpenAIPromptDirectory/WTH-Challenge-Template-Prompt.txt" \
    "Generate a student challenge page of the hack based upon the following description: $openAIHackDescription. This should be for Challenge $suffixNumber." \
    "$fullPath/$prefix-$suffixNumber.md")

  echo "$openAIResponse"
}

CreateSolutionMarkdownFile() {
  local -r fullPath=$1
  local -r prefix=$2
  local -r suffixNumber=$3
  local -r challengeResponse=$4

  local -r openAIResponse=$(WriteMarkdownFile "$pathToOpenAIPromptDirectory/WTH-Challenge-Solution-Prompt.txt" \
    "Generate a coach's guide solutiion page of the hack based upon the following description: $openAIHackDescription. This should be for solution $suffixNumber. It should be the step-by-step solution to the following challenge description: $challengeResponse" \
    "$fullPath/$prefix-$suffixNumber.md")

  #echo "$openAIResponse"
}

CreateChallengesAndSolutions() {
  local -r numberOfChallenges=$1

  for challengeNumber in $(seq -f "%02g" 0 $numberOfChallenges); do
    if $verbosityArg; then
      echo "Creating $rootPath/Challenge-$challengeNumber.md..."
    fi

    local challengeResponse=$(CreateChallengeMarkdownFile "$rootPath/Student" "Challenge" $challengeNumber $numberOfChallenges)

    if $verbosityArg; then
      echo "Creating $rootPath/Solution-$challengeNumber.md..."
    fi

    CreateSolutionMarkdownFile "$rootPath/Coach" "Solution" $challengeNumber $numberOfChallenges "$challengeResponse"
  done

  CreateCoachGuideMarkdownFile "$rootPath/Coach" $numberOfChallenges
}

CreateCoachGuideMarkdownFile() {
  local -r fullPath=$1
  local -r numberOfSolutions=$2

  if $verbosityArg; then
    echo "Creating $fullPath/README.md..."
  fi

  local -r openAIResponse=$(WriteMarkdownFile "$pathToOpenAIPromptDirectory/WTH-CoachGuide-Prompt.txt" \
    "Generate a coach's guide overview page of the hack based upon the following description: $openAIHackDescription" \
    "$fullPath/README.md")

  #echo "$openAIResponse"
}

# Main program
declare verbosityArg=false
declare removeExistingDirectoryArg=false

while getopts ":c:rhn:d:k:e:a:p:v" option; do
  case $option in
    c) numberOfChallengesArg=${OPTARG};;
    r) removeExistingDirectoryArg=true;;
    h) Help
       exit;;
    n) nameOfHackArg=${OPTARG};;
    p) pathArg=${OPTARG};;
    d) descriptionOfHackArg=${OPTARG};;
    k) keywordsArg=${OPTARG};;
    e) openAIEndpointUriArg=${OPTARG};;
    a) openAIApiKeyArg=${OPTARG};;
    v) verbosityArg=true
  esac
done

if $verbosityArg; then
  echo "Number of Challenges: $numberOfChallengesArg"
  echo "Name of Challenge: $nameOfHackArg"
  echo "Path: $pathArg"
  echo "Remove existing directory: $removeExistingDirectoryArg"
  echo "Description of the hack: $descriptionOfHackArg"
  echo "Keywords for the hack: $keywordsArg"
  echo "OpenAI Endpoint URI: $openAIEndpointUriArg"
fi

declare -r wthDirectoryName="xxx-$nameOfHackArg"

declare -r rootPath="$pathArg/$wthDirectoryName"

declare -r pathToTemplateDirectory="$pathArg/$templateDirectoryName"

declare -r pathToOpenAIPromptDirectory="$pathToTemplateDirectory/$openAIPromptDirectoryName"

declare -r descriptionOfHack="$descriptionOfHackArg"

declare -r keywords="$keywordsArg"

declare -r openAIEndpointUri="$openAIEndpointUriArg"

declare -r openAIApiKey="$openAIApiKeyArg"

CreateDirectoryStructure $removeExistingDirectoryArg

declare -r openAIHackDescription=$(CreateHackDescription $numberOfChallengesArg)

CreateChallengesAndSolutions $numberOfChallengesArg
