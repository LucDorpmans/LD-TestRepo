configuration IISConfigDemoToo
{
  Import-DscResource -Module 'xWebAdministration'
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

  node ("localhost") {

    WindowsFeature IIS {
       Ensure = "Present"
       Name   = "Web-Server"
    }
    WindowsFeature AspNet45 {
        Ensure = "Present"
        Name   = "Web-Asp-Net45"
    }
    xWebsite DemoSite {
        Ensure       = "Present"
        Name         = "Demo Web Site"
        State        = "Stopped"
        PhysicalPath = "C:\inetpub\DemoSite"
        DependsOn    = "[WindowsFeature]IIS"
    }
  }
}
IISConfigDemoToo -OutputPath:'C:\Demo\IISConfigDemoToo'
