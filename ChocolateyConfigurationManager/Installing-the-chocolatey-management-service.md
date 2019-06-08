# Installing chocolatey-management-service

## Assumptions

* The database has been installed and is accessible according to the [steps described here](https://github.com/verzada/FakeChocDoc/blob/UnOfficial/ChocolateyConfigurationManager/Installing-the-database-component.md)
* There is an Active Directory user account (preferably service account) available if needed

**NOTE:** It is likely that additional package parameters are required which are specific to your environment. Please carefully review the available package parameters before proceeding.

In order to successfully install the chocolatey-management-service package onto a machine (using all default values), the following steps are required:

**NOTE:** Due to an issue that was identified in the initial release of CCM, the port number parameter is required.

``` powershell
chocolatey --version 0.10.15
chocolatey.extension --version 2.0.2
chocolatey-agent --version 0.9.1
chocolatey-management-service --version 0.1.0
```

## Package Parameters
This package creates the CCM Service with the following defaults:

* Service Name: **chocolatey-management-service**
* Service Displayname: **Chocolatey Management Service**
* Description: **Chocolatey Management Service is a background service for Chocolatey.**
* Service Startup: **Automatic**
* Service Username: **ChocolateyLocalAdmin**
* Database Connection String: **Server=<LOCAL COMPUTER FQDN NAME>; Database=ChocolateyManagement; Trusted_Connection=True;**
* Service Listening Port: **24020**
* Self-Signed Certificate Domain Name: **DNS name of the local computer**

You can override the package defaults using the following parameters:

* ```/Username```
  * Username to install the management service as;
  * **NOTE:** Default Value: ChocolateyLocalAdmin
* ```/Password```
  * Password to use for the management service account;
  * **NOTE:** Automatically generated secure password
* ```/EnterPassword```
  * This will prompt you to enter the password, during install, for the username (provided via the ```/Username``` parameter) the management service will run under;
  * **NOTE:** Default Value: Not provided
* ```/ConnectionString```
  * The SQL Server database connection string to be used to connect to the CCM database;
  * **NOTE:** Default Value: **Server=\<LOCAL COMPUTER FQDN NAME\>; Database=ChocolateyManagement; Trusted_Connection=True;**
* ```/Database```
  * Name of the SQL Server database to use. Note that if you do not also pass ```/ConnectionString```, it will be generated using this parameter value and ```/SqlServerInstance``` (using defaults for missing parameters);
  * **NOTE:** Default Value: **ChocolateyManagement**
* ```/SqlServerInstance```
  * Instance name of the SQL Server database to connect to. Note that if you do not also pass ```/ConnectionString```, it will be generated using this parameter value and ```/Database``` (using defaults for missing parameters);
  * **NOTE:** Default Value: **\<LOCAL COMPUTER FQDN NAME\>**
* ```/PortNumber```
  * The port the Chocolatey Management Service will listen on. This will automatically create a rule to open the firewall on this port;
  * **NOTE:** Default Value **24020**
* ```/CertificateDnsName```
  * The DNS name of the self-signed certificate that is generated if no existing certificate thumbprint is provided using the ```/CertificateThumbprint``` parameter is provided;
  * **NOTE:** Default Value: **\<LOCAL COMPUTER FQDN NAME\>**
* ```/CertificateThumbprint```
  * By default the CCM Service uses a self-signed SSL certificate to secure communication with the clients. Use this parameter to provide the thumbprint of a certificate to use instead. **Note that if you use this the certificate must already be in the LocalMachine\TrustedPeople Certificate Store on the Chocolatey Management Service computer;**
  * **NOTE:** Default Value: Not applicable as if not provided, a new Self Signed Certificate will be generated
* ```/NoRestartService```
  * Explicit request not to restart the service
  * **NOTE:** Default Value: Not provided
* ```/DoNotReinstallService```
  * Explicit request not to reinstall the service
  * **NOTE:** Default Value: Not provided

## Example
Let's assume that you want to install the CCM Service with a specific connection string in order to connect to the CCM Database, as well as configure the CCM Service to use a specific user name and password, as well as alter the Port number that the CCM Service will be hosted on. The necessary installation command would look like the following:

``` powershell
choco upgrade chocolatey-management-service --package-parameters-sensitive="'/PortNumber=24021 /Username=ccmtest\ccmservice /Password=Password01 /ConnectionString=""Server=MACHINE1\SQLSERVERCCM;Database=ChocolateyManagement;User ID=ccmtest\ccmservice;Password=Password01;""'"
```
**NOTE:** This command makes use of package-parameters-sensitive to ensure that the sensitive information is not leaked out into log files.

# Powershell example

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

Function ManagementService() {
     choco upgrade chocolatey-management-service -y --version 0.1.0 --params="/PortNumber=24020 /ConnectionString=$connectionString'"

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


ManagementService
```
