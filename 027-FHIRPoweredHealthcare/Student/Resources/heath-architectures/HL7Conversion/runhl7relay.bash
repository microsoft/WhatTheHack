#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

declare functionurl=""
declare functionkey=""
declare hl7relayports="8079"
declare hl7relayimage="stodocker/hl7overhttp-relay"
usage() { echo "Usage: $0 <HL7FunctionAppURL> <HL7FunctionAppKey>" 1>&2; exit 1; }

if [ "$#" -ne 2 ]; then
    usage
fi
functionurl=$1
functionkey=$2

#Start deploy
echo "Starting HL7Relay..."
(
	set -x
		#Run HL7 Relay
		docker run -itd --rm  -p $hl7relayports:$hl7relayports -e HL7OVERHTTPHEADERS=x-functions-key=$functionkey -e HL7OVERHTTPDEST=$functionurl $hl7relayimage
)

if [ $?  == 0 ];
 then
	echo "HL7 Relay Started..."
fi
