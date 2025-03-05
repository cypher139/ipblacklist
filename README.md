# Cypher's IP Addresses Blacklist

The longer I run a Minecraft server on the typical port, the more IP addresses that are clearly not actual players attempt to ping it.  
I've seen IPs originating from:
 - Script kiddies perusing the open internet, either from VPN or VPS services  
 - Professional security companies checking for vulnerabilities  
 - Scam / spam players looking for any server just to spam unwanted adverts and leave  
  
Over the past year or so I've collected quite the list of addresses; it's now time to release updates automatically as the server receives and processes them.  
As far as I'm concerned, letting these IPs past your firewall provides no real value to your services and computers.  

## Releases
Rolling release model: Latest additions are committed daily.  
- To add the IP list to your firewall, download [block.txt](block.txt).  
- Additional reports breaking down various aspects of the IPs are located in the [Reports](Reports/) folder, or peruse the gist of it at [Report.txt](Report.txt).  
- If you use my Chat script in CommandHelper on your Minecraft server, download IPBlacklist.yml to the Chat script's Configs folder.  
- See the [Example Scripts](Example%20Scripts/) folder for some examples of uploading IPs to your firewall. 

### Sources
This blacklist is primarily generated from received pings to Minecraft server(s), that the server never observed any players attempt to play using the stated IP address.  
Steps have been taken to ensure this list does not catch legit players that just added the server to their server list and forgot to actually play.  

### IP Removal Process
If you find your IP on this blacklist, chances are that you are running a scanner on the Internet, or your company bought misused IPs. 99% of the IPs on the list fall under this criteria and therefore will not be removed.  
If you are a legit Minecraft player, found your IP on the list, and are trying to play on any affected servers, contact cypher139. Note: Due to the above reason(s) removal from this blacklist requires sufficient proof that the IP in question is not used for any bad activities.