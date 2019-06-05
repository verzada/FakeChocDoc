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
