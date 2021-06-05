configuration IISDemoConfig
{
     Import-DscResource -Module 'xWebAdministration'
     Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

     node ("localhost") {

          WindowsFeature IIS {
               Ensure = "Present"
               Name   = "Web-Server"
          }
          WindowsFeature IISManagementTools {
               Ensure    = "Present"
               Name      = "Web-Mgmt-Tools"
               DependsOn = '[WindowsFeature]IIS'
          }
          WindowsFeature AspNet45 {
               Ensure = "Present"
               Name   = "Web-Asp-Net45"
          }
          xWebsite DefaultSite {
               Ensure       = "Present"
               Name         = "Demo Web Site"
               State        = "Stopped"
               PhysicalPath = "C:\inetpub\wwwroot"
               DependsOn    = "[WindowsFeature]IIS"
          }
     }
}
IISDemoConfig -OutputPath:'C:\Demo\IISDemoConfig'
