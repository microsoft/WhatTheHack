#!/bin/bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

declare -r templateDirectoryName="000-HowToHack"

Help() {
   echo "Syntax: createWthTemplate [-c|d|h|n|p|v]"
   echo "options:"
   echo "c     How many challenges to stub out."
   echo "d     Delete existing directory with same name."
   echo "h     Print this Help."
   echo "n     Name of the new WhatTheHack. This must be a valid directory name"
   echo "p     Path to where to create new WhatTheHack directory."
   echo "v     Verbose mode."
   echo
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

  if $verbosityArg; then
    echo "Creating $rootPath/Student/Resources directories..."
  fi

  # create the Student & Student/Resources directories
  mkdir -p $rootPath/Student/Resources
}

PreprocessTemplateFile() {
  local -r pathToFile=$1

  local initialText=$(cat $pathToFile)

  #replaces the REMOVE_ME placeholder (singleline), the REPLACE_ME placeholder (multiline) & collapse extra newlines
  local -r returnText=$(echo "$initialText" | sed -e 's/<!-- REMOVE_ME \(.*\${.*}.*\) (.*) REMOVE_ME -->/\1/g' | perl -0777 -pe "s/<!-- REPLACE_ME .*? -->(?:.*?)<!-- REPLACE_ME .*? -->//gsm" | perl -0777 -pe "s/(\R)(?:\h*\R)+/\$1\$1/g")

  echo "$returnText"
}

WriteMarkdownFile() {
  local -r pathToWriteTo=$1
  local -r markdownTemplateFileName=$2

  local -r pathToTemplate="$pathToTemplateDirectory/$markdownTemplateFileName"

  local templateText=$(PreprocessTemplateFile "$pathToTemplate")

  #read in the template file & replace predefined variables 
  #(defined in the file as ${varName})
  local template=$(eval "cat <<EOF
$templateText
EOF
" 2> /dev/null)

  cat > "$pathToWriteTo" <<< $template
}

GenerateChallengesSection() {
  local -r numberOfChallenges=$1
  local -r directoryName=$2
  local -r typeName=$3

  local challengesSection=""

  for challengeNumber in $(seq -f "%02g" 1 $numberOfChallenges); do
    eval challengesSection+=\$\'1. Challenge $challengeNumber: **[Description of challenge]\($directoryName/$typeName-$challengeNumber.md\)**\\n\\t - Description of challenge\\n\'
  done

  echo "$challengesSection"
}

CreateHackDescription() {
  local -r numberOfChallenges=$1

  if $verbosityArg; then
    echo "Creating $rootPath/README.md..."
  fi

  local -r challengesSection=$(GenerateChallengesSection $numberOfChallenges "Student" "Challenge")

  WriteMarkdownFile "$rootPath/README.md" "WTH-HackDescription-Template.md"
}

GenerateNavitationLink() {
  local -r suffixNumber=$1
  local -r numberOfChallenges=$2
  local -r linkName=$3
  local -r isCoachGuide=$4

  local navigationLine=""

  local previousNavigationLink=""

  #have to account for the fact that there is 0 at the beginning of the challenge number, a 08 is interpreted as octal
  #therefore, the $((10#$suffixNumber)) syntax
  if [[ $((10#$suffixNumber)) -gt 1 ]]; then
    local -r previousChallengeNumber=$(printf %02d $((10#$suffixNumber - 1)))
    previousNavigationLink="[< Previous $linkName](./$linkName-$previousChallengeNumber.md) - "
  fi

  local nextNavigationLink=""

  #have to account for the fact that there is 0 at the beginning of the challenge number, a 08 is interpreted as octal
  #therefore, the $((10#$suffixNumber)) syntax
  if [[ $((10#$suffixNumber)) -lt $((10#$numberOfChallenges)) ]]; then
    local -r nextChallengeNumber=$(printf %02d $((10#$suffixNumber + 1)))
    nextNavigationLink=" - [Next $linkName >](./$linkName-$nextChallengeNumber.md)"
  fi

  local homeLinkPath=""
  
  #if the navigation link is for Coach guides, it should point to the Coach/README, not the root README file
  if $isCoachGuide
  then
    homeLinkPath="."
  else  
    homeLinkPath=".."
  fi

  local -r navigationLine="$previousNavigationLink**[Home]($homeLinkPath/README.md)**$nextNavigationLink"

  echo $navigationLine
}

CreateChallengeMarkdownFile() {
  local -r fullPath=$1
  local -r prefix=$2
  local -r suffixNumber=$3
  local -r numberOfChallenges=$4

  if $verbosityArg; then
    echo "Creating $fullPath/$prefix-$suffixNumber.md..."
  fi

  local -r navigationLine=$(GenerateNavitationLink $suffixNumber $numberOfChallenges "Challenge" false)

  WriteMarkdownFile "$fullPath/$prefix-$suffixNumber.md" "WTH-Challenge-Template.md"
}

CreateSolutionMarkdownFile() {
  local -r fullPath=$1
  local -r prefix=$2
  local -r suffixNumber=$3

  if $verbosityArg; then
    echo "Creating $fullPath/$prefix-$suffixNumber.md..."
  fi

  local -r navigationLine=$(GenerateNavitationLink $suffixNumber $numberOfChallenges "Solution" true)

  WriteMarkdownFile "$fullPath/$prefix-$suffixNumber.md" "WTH-Challenge-Solution-Template.md"
}

CreateChallenges() {
  local -r fullPath=$1
  local -r numberOfChallenges=$2

  if $verbosityArg; then
    echo "Creating $numberOfChallenges challenge Markdown files in $fullPath..."
  fi

  for challengeNumber in $(seq -f "%02g" 1 $numberOfChallenges); do
    CreateChallengeMarkdownFile "$fullPath" "Challenge" $challengeNumber $numberOfChallenges
  done
}

CreateCoachGuideMarkdownFile() {
  local -r fullPath=$1
  local -r numberOfSolutions=$2

  if $verbosityArg; then
    echo "Creating $fullPath/README.md..."
  fi

  local -r challengesSection=$(GenerateChallengesSection $numberOfChallenges "." "Solution")

  WriteMarkdownFile "$fullPath/README.md" "WTH-CoachGuide-Template.md"
}

CreateSolutions() {
  local -r fullPath=$1
  local -r numberOfSolutions=$2

  CreateCoachGuideMarkdownFile "$fullPath" $numberOfChallenges

  if $verbosityArg; then
    echo "Creating $numberOfSolutions solution Markdown files in $fullPath..."
  fi

  for solutionNumber in $(seq -f "%02g" 1 $numberOfSolutions); do
    CreateSolutionMarkdownFile "$fullPath" "Solution" $solutionNumber
  done
}

CreateChallengesAndSolutions() {
  local -r numberOfChallenges=$1

  if $verbosityArg; then
    echo "Creating $numberOfChallenges solution & challenge Markdown files in $rootPath..."
  fi

  CreateSolutions "$rootPath/Coach" $numberOfChallenges

  CreateChallenges "$rootPath/Student" $numberOfChallenges
}

# Main program
declare verbosityArg=false
declare deleteExistingDirectoryArg=false

while getopts ":c:dhn:p:v" option; do
  case $option in
    c) numberOfChallengesArg=${OPTARG};;
    d) deleteExistingDirectoryArg=true;;
    h) Help
       exit;;
    n) nameOfChallengeArg=${OPTARG};;
    p) pathArg=${OPTARG};;
    v) verbosityArg=true
  esac
done

if $verbosityArg; then
  echo "Number of Challenges: $numberOfChallengesArg"
  echo "Name of Challenge: $nameOfChallengeArg"
  echo "Path: $pathArg"
  echo "Delete existing directory: $deleteExistingDirectoryArg"
fi

declare -r wthDirectoryName="xxx-$nameOfChallengeArg"

declare -r rootPath="$pathArg/$wthDirectoryName"

declare -r pathToTemplateDirectory="$pathArg/$templateDirectoryName"

CreateDirectoryStructure $deleteExistingDirectoryArg

CreateHackDescription $numberOfChallengesArg

CreateChallengesAndSolutions $numberOfChallengesArg
