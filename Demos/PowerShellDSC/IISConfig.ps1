configuration IISConfig
{
  Import-DscResource -Module 'xWebAdministration'
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

  node ("localhost") {

    WindowsFeature IIS {
       Ensure = "Present"
       Name   = "Web-Server"
    }
    WindowsFeature AspNet45 {
        Ensure = "Present"
        Name   = "Web-Asp-Net45"
    }
    xWebsite DefaultSite {
        Ensure       = "Present"
        Name         = "Default Web Site"
        State        = "Stopped"
        PhysicalPath = "C:\inetpub\wwwroot"
        DependsOn    = "[WindowsFeature]IIS"
    }
  }
}
IISConfig -OutputPath:'C:\Demofiles\IISConfig'
