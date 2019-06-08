# Installation requirements for Chocolatey Configuration Manager

### Requirements

1. The chocolatey license source is installed and available (the same one used to install the Chocolatey Agent and Chocolatey Extension)
1. Chocolatey with a C4B license installed on the clients running the agents
1. An Active Directory (preferably service) account with membership in the local Administrator group running the agent service 
1. Chocolatey with a C4B license installed on the server(s) running the managment and web service
1. Windows Server 2012 and upward
1. SQL Server 2012 database and upward

### Considerations

If the enviroment CCM is installed into, is heavily restricted. Do not use an machine account for the agent and management service, since it's probably that they cannot send nor receive information between them in the network. There can also be restriction on an machine user if there's a proxy as well.

### Installation process
The installation process needs to be done in this order:

1. Chocolatey 
1. Chocolatey extension
1. Chocolatey agent
1. The database
1. The management service
1. The web service
1. Adding agents to clients with url to the managment service

Both the management service and the web service requires the database and therefore must be readily accessible. This is usually not a problem if the managment service and web service is running on the same server as the database.

Lets start with 
[installing the database ](Installing chocolatey-management-database)
