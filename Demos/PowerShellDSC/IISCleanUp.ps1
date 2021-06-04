# A configuration to configure / cleanup a default IIS instance
Configuration IISCleanUp
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration','xWebAdministration'
    xWebAppPool RemoveDotNet2Pool         { Name = ".NET v2.0";            Ensure = "Absent"}
    xWebAppPool RemoveDotNet2ClassicPool  { Name = ".NET v2.0 Classic";    Ensure = "Absent"}
    xWebAppPool RemoveDotNet45Pool        { Name = ".NET v4.5";            Ensure = "Absent"}
    xWebAppPool RemoveDotNet45ClassicPool { Name = ".NET v4.5 Classic";    Ensure = "Absent"}
    xWebAppPool RemoveClassicDotNetPool   { Name = "Classic .NET AppPool"; Ensure = "Absent"}
    xWebAppPool RemoveDefaultAppPool      { Name = "DefaultAppPool";       Ensure = "Absent"}
    xWebSite    RemoveDefaultWebSite      { Name = "Default Web Site";     Ensure = "Absent"; PhysicalPath = "C:\inetpub\wwwroot"}
    xWebSite    RemoveDemoWebSite         { Name = "Demo Web Site";        Ensure = "Absent"; PhysicalPath = "C:\inetpub\demosite"}
}

IISCleanUp -OutputPath:'C:\Demo\IISCleanUp'

