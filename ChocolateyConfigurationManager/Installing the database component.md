# Installing chocolatey-management-database
NOTE: It is likely that additional package parameters are required which are specific to your environment. Please carefully review the available package parameters before proceeding.

In order to successfully install the chocolatey-management-database package onto a machine (using all default values), the following steps are required:

## Package requirements
``` powershell
  choco upgrade chocolatey --version 0.10.15
  choco upgrade chocolatey.extension --version 2.0.2
  choco upgrade chocolatey-agent --version 0.9.1
  choco upgrade chocolatey-management-database --version 0.1.0
```

## Package Parameters
This package creates the CCM Database with the following defaults:

Database Connection String: Server=<LOCAL COMPUTER FQDN NAME>; Database=ChocolateyManagement; Trusted_Connection=True;
You can override the package defaults using the following parameters:

* ```/ConnectionString ```
  * The SQL Server database connection string to be used to connect to the CCM database.
  * NOTE: Default Value: **Server=<LOCAL COMPUTER FQDN NAME>; Database=ChocolateyManagement; Trusted_Connection=True;**
* ```/Database ```
  * Name of the SQL Server database to use. Note that if you do not also pass ```/ConnectionString```, it will be generated using this parameter value and ```/SqlServerInstance``` (using defaults for missing parameters);
  * NOTE: Default Value: ChocolateyManagement
* ```/SqlServerInstance```
  * Instance name of the SQL Server database to connect to. Note that if you do not also pass ```/ConnectionString```, it will be generated using this parameter value and ```/Database``` (using defaults for missing parameters);
  * NOTE: Default Value: **<LOCAL COMPUTER FQDN NAME>**

**Example**
Let's assume that you want to install the CCM Database onto a machine that will access a SQL Server instance called ```SQLSERVERCCM```, on a domain machine called ```MACHINE1``` which is part of the domain ccmtest, using a specific user name (ccmservice) and password combination. In this scenario, the installation command would look like the following:

``` Powershell
choco upgrade chocolatey-management-database --package-parameters-sensitive="'/ConnectionString=""Server=MACHINE1\SQLSERVERCCM;Database=ChocolateyManagement;User ID=ccmtest\ccmservice;Password=Password01;""'"
```
**NOTE:** This command makes use of package-parameters-sensitive to ensure that the sensitive information is not leaked out into log files.
