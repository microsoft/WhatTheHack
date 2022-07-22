# Challenge 1: Coach's Guide

[< Previous Challenge](./Challenge-00.md) - **[Home](README.md)** - [Next Challenge >](./Challenge-02.md)

## Notes & Guidance

Commands to run to create variables (substitute XXX for the unique prefix):

For Bash:

```bash
export loc="centralus"
export rg="rg-XXX"
```

For Powershell:

```powershell
$loc = "centralus"
$rg = "rg-XXX"
```

```az group create --name $rg --location $loc --subscription $sub```