# Installing chocolatey-management-database
NOTE: It is likely that additional package parameters are required which are specific to your environment. Please carefully review the available package parameters before proceeding.

In order to successfully install the chocolatey-management-database package onto a machine (using all default values), the following steps are required:

## Package requirements
``` powershell
  chocolatey --version 0.10.15
  chocolatey.extension --version 2.0.2
  chocolatey-agent --version 0.9.1
  chocolatey-management-database --version 0.1.0
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
**NOTE:** This command makes use of **package-parameters-sensitive** to ensure that the sensitive information is not leaked out into log files. The AppSettings.json file will still contain an encrypted connectionstring even if **package-parameters-sensitive** is switched out with  **package-parameters** or **params**

## Powershell script for Database installation example

``` powershell
 # Find FDQN for current machine

 
$hostName = HostName()
$databaseServer = 'FQDN.default.domain';
$databaseName = 'ChocolateyCentralManagement'
$databasePassword = 'YourDatabaseUserPassword';
$databaseUser = 'YourDatabaseUserName';
$connectionString = ""Server=$databaseServer;Database=$databaseName;User ID=$databaseUser;Password=$databasePassword;""
$databaseConnectionString = "'/ConnectionString=$connectionString'"


Function HostName() {
	$hostName = [System.Net.Dns]::GetHostName()
	$domainName = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().DomainName
 
	if(-Not $hostName.endswith($domainName)) {
  		$hostName += "." + $domainName
	}
	return $hostName
}

Function PreReqs() {
    choco upgrade chocolatey -y --version 0.10.15
    choco upgrade chocolatey.extension -y --version 2.0.2
    choco upgrade chocolatey-agent -y --version 0.9.1
}

Function Database() {
    choco upgrade chocolatey-management-database -y --params="'/PortNumber=24020'" --package-parameters=$databaseConnectionString
}

Function ManagementService() {
     choco upgrade chocolatey-management-service -y -s C:\temp\choco\chocolatey-management-service.0.1.0.nupkg --version 0.1.0 --params="/PortNumber=24020 /ConnectionString=$connectionString'"

    CCMSetup
}

Function CCMSetup() {
    choco config set --name="'centralManagementReportPackagesTimerIntervalInSeconds'" --value="'1860'"
    choco config set --name="'centralManagementServiceUrl'" --value="'https://$($hostname):24020/ChocolateyManagementService'"
    choco config set --name="'centralManagementReceiveTimeoutInSeconds'" --value="'60'"
    choco config set --name="'centralManagementSendTimeoutInSeconds'" --value="'60'"
    choco config set --name="'centralManagementCertificateValidationMode'" --value="'PeerOrChainTrust'"
    choco feature enable --name="'useChocolateyCentralManagement'"
}

Function Web {

    choco upgrade aspnetcore-runtimepackagestore -y
    choco upgrade dotnetcore-windowshosting -y
    choco upgrade chocolatey-management-web -y  --package-parameters=$databaseConnectionString --force
}


Function UnInstall(){
    choco uninstall chocolatey-management-database chocolatey-management-web -y

}

PreReqs
Database
Web
```

