# A configuration to install default IIS instance
Configuration IISRemove
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    WindowsFeature IIS {
        Ensure = "Absent"
        Name = "Web-Server"
    }
    WindowsFeature IISManagementTools
    {
        Ensure = "Absent"
        Name = "Web-Mgmt-Tools"
        DependsOn='[WindowsFeature]IIS'
    }
}

IISRemove -OutputPath:'C:\Demo\IISRemove'