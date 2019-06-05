---
title: Installation Requirements
description: Software arequirements for installing the Chocolatey Configuration Manager.
position: 1
---

### Requirements

* The chocolatey license source is available (the same one used to install the Chocolatey Agent and Chocolatey Extension)
* Chocolatey with a C4B license installed on the server(s) running the managment and web service
* Windows Server 2012 and upward
* SQL Server 2012 database

### Installation process
The installation process needs to be done in this order:

1. The database
1. The management service
1. The web service
1. Adding agents to clients with url to the managment service

Both the management service and the web service requires the database and therefore must be readily accessible. This is usually not a problem if the managment service and web service is running on the same server.
