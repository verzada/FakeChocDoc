# Installing chocolatey-management-web

## Assumptions

The agent, management database and the management service has been installed and are running properly according to the previous steps in the guide.

## Notes

#### Package parameters

**NOTE:** It is likely that additional package parameters are required which are specific to your environment. Please carefully review the available **package parameters** before proceeding.

#### Username and password
**NOTE:** Once installed, when you access the CCM Website you will be prompted to provide a username and password to access the site. 
By default the username and password are: 
* the username is ```ccmadmin``` 
* the password is ```123qwe```. 

After you input the username and password, you will be prompted to change the password.

#### Requirements 
In order to successfully install the chocolatey-management-web package onto a machine (using all default values), the following packages are required:

``` powershell
aspnetcore-runtimepackagestore
dotnetcore-windowshosting
chocolatey --version 0.10.15
chocolatey.extension --version 2.0.2
chocolatey-agent --version 0.9.1
chocolatey-management-web --version 0.1.0
```

#### Package Parameters
This package creates the CCM Website and Application Pool with the following defaults:

* IIS Web Application Pool: **ChocolateyCentralManagement**
  * enable32BitAppOnWin64: **True**
  * managedPipelineMode: **Integrated****
  * managedRuntimeVersion: **<blank>**
  * startMode: **AlwaysRunning**
  * processModel.idleTimeout: **0**
  * recycling.periodicRestart.schedule: **Disabled**
  * recycling.periodicRestart.time: **0**
  * Website Name: **ChocolateyCentralManagement**
  * PortBinding: **80**
  * applicationDefaults.preloadEnabled: **True**
  * SQL Server Instance: **<LOCAL COMPUTER FQDN NAME>**
  * Connection String: **Server=<LOCAL COMPUTER FQDN NAME>; Database=ChocolateyManagement; Trusted_Connection=True;**

You can override the package defaults using the following parameters:

* ```/ConnectionString```
  * The SQL Server database connection string to be used to connect to the CCM Database;
  * **NOTE:** Default Value: **Server=<LOCAL COMPUTER FQDN NAME>; Database=ChocolateyManagement; Trusted_Connection=True;**
* ```/Database```
  * Name of the SQL Server database to use. Note that if you do not also pass ```/ConnectionString```, it will be generated using this parameter value and ```/SqlServerInstance``` (using defaults for missing parameters);
  * **NOTE:** Default Value: ChocolateyManagement
* ```/SqlServerInstance```
  * Instance name of the SQL Server database to connect to. Note that if you do not also pass /ConnectionString, it will be generated using this parameter value and /Database (using defaults for missing parameters);
  * NOTE: Default Value: <LOCAL COMPUTER FQDN NAME>
* ```/Username```
  * The username that the **IIS WebApplicationPool will run under**. If this is not provided the pool will run under the default account. Note that if you provide this you must also provide either the /Password or /EnterPassword parameter;
  * NOTE: Default Value: IIS APPPOOL\ChocolateyCentralManagement
* ```/Password```
  * The password for the **username (provided via the /Username parameter) the IIS WebApplicationPool** will run under;
  * NOTE: Automatically generated secure password
* ```/EnterPassword```
  * This will prompt you to enter the password, during install, for the username (provided via the /Username parameter) the IIS WebApplicationPool will run under;
  * NOTE: Default Value: Not provided

#### Example
Let's assume that you want to install the CCM Website with a specific connection string in order to connect to the CCM Database, as well as configure the IIS Application Pool to use a specific user name and password. The necessary installation command would look like the following:

``` powershell
choco upgrade chocolatey-management-web --package-parameters-sensitive="'/ConnectionString=""Server=MACHINE1\SQLSERVERCCM;Database=ChocolateyManagement;User ID=ccmtest\ccmservice;Password=Password01;"" /Username=ccmwebserver\ccmserviceuser /Password=Password01'"

```

**NOTE:** This command makes use of ```package-parameters-sensitive``` to ensure that the sensitive information is not leaked out into log files.
