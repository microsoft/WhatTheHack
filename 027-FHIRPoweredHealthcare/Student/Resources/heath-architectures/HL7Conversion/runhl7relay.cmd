@echo off
setlocal enableextensions enabledelayedexpansion
set argC=0
for %%x in (%*) do Set /A argC+=1
if not %argC% == 2 (
	echo Usage %~n0: [HL7FunctionAppURL] [HL7FunctionAppKey]
	exit /b
)
echo Running hl7relay....
docker run -it --rm  -p 8079:8079 -e HL7OVERHTTPHEADERS=x-functions-key=%2 -e HL7OVERHTTPDEST=%1 stodocker/hl7overhttp-relay
