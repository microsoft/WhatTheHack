# Cheat sheet for Cisco IOS commands

This list is by no means comprehensive, but it is conceived to give some of the most useful commands for admins new to the Cisco CLI

* **`configure terminal`**: enter configuration mode
* **`write memory`**: save the config to non-volatile storage (preserve config after reboot)
* **`show ip interface brief`**: show a summary of the network interfaces in the system
* **`show ip bgp summary`**: show the status of configured BGP adjacencies
* **`show ip route`**: show the system routing table
* **`show ip route `_`<ip-address>`_**: show routing table information for a particular IP address
* **`show ip route bgp`**: show the BGP routes in the routing table
* **`show ip bgp `_`<ip-address>`_**: show BGP candidate routes for a particular IP address
* **
* **`clear ip bgp *`**: clear all BGP neighborship status (force peers to re-establish)
* **`clear ip bgp `_`<peer-ip-address>`_** clear BGP neighborship with a particular peer (force it to re-establish), resetting things like route age timers
* **
* **`terminal monitor`**: show system feedback that normally would only be visible in a serial console connection
* **`debug ip bgp`**: show system feedback about BGP peering operations (remember to use **`terminal monitor`** first)
* **
* **`do` _`[command]`_**: useful for running commands that are not available in configuration mode, while in configuration mode. Examples:
  * **`do show ip bgp summary`** after configuring BGP router details
  * **`do show ip route bgp`** after configuring BGP route-maps
  * **`do write memory`** after updating configuration, without needing to leave configuration mode
