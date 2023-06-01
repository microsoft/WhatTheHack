#!/bin/bash -l

echo "Starting..."
configFile="$1"; shift
pathToMarkdownFiles="$1"; shift
changedFiles=("$@")

echo "Config file: $configFile"
echo "Path to markdown files: $pathToMarkdownFiles"
echo "Changed files: ${changedFiles[@]}"

echo "Setup languages and spelling tool..."

python /generate-spellcheck.py "$configFile" "$pathToMarkdownFiles" "${changedFiles[@]}"

# convert from JSON to YAML
yq -P "$configFile".tmp > "$configFile"

rm -rf /var/lib/apt/lists/*

echo "Using PySpelling according to configuration from $configFile"

pyspelling --config "$configFile"

EXITCODE=$?

test $EXITCODE -gt 1 && echo "Spelling check action failed, please check logs.";

test $EXITCODE -eq 1 && echo "Files in repository contain spelling errors. Please fix these errors. Alternatively, follow the instructions at the following link to add your own words to the dictionary: https://microsoft.github.io/WhatTheHack/CONTRIBUTING.html#spell-check";

exit $EXITCODE