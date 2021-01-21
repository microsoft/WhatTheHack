# Challenge 3: Offline migration

[< Previous Challenge](./02-size-analysis.md) - **[Home](../README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

## Proctor Tips

1) The attendees will not be able to connect to Azure DB for PostgreSQL/MySQL from within the container until they add the public IP address that the container is using for egress. One way to find it is to do this:
```shell

apt update
apt install curl
curl ifconfig.me

```


