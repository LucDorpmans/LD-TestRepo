configuration IISConfigDefault
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
        State        = "Started"
        PhysicalPath = "C:\inetpub\wwwroot"
        DependsOn    = "[WindowsFeature]IIS"
    }
  }
}
IISConfigDefault -OutputPath:'C:\Demo\IISConfigDefault'
