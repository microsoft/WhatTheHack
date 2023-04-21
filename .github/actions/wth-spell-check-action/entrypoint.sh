#!/bin/sh -l

echo ""
echo ">>> Tools & Versions"
echo "> python $(python --version)"
echo ""
echo "> pip3 $(pip --version)"
echo ""
echo "> pyspelling $(pip3 show pyspelling)"
echo ""
echo "> pyyaml $(pip3 show pyyaml)"
echo "<<<"
echo ""

echo "Starting..."
echo "Setup languages and spelling tool..."
python /generate-spellcheck.py "$1" "$2"

yq -P "$1".tmp > "$1"

rm -rf /var/lib/apt/lists/*

echo "Using PySpelling according to configuration from $1"

pyspelling --config "$1"

EXITCODE=$?

test $EXITCODE -gt 1 && echo "\033[91Spelling check action failed, please check diagnostics\033[39m";

test $EXITCODE -eq 1 && echo "\033[91mFiles in repository contain spelling errors\033[39m";

exit $EXITCODE