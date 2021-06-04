# A configuration to install default IIS instance
Configuration IISInstall
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    WindowsFeature IIS {
        Ensure = "Present"
        Name = "Web-Server"
    }
    WindowsFeature IISManagementTools
    {
        Ensure = "Present"
        Name = "Web-Mgmt-Tools"
        DependsOn='[WindowsFeature]IIS'
    }
}

IISInstall -OutputPath:'C:\Demo\IISInstall'