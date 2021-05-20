$LabConfig = @{ DomainAdminName = 'LabAdmin'; AdminPassword = 'LS1setup!'; Prefix = 'SDNExpress2019-'; SecureBoot = $false; SwitchName = 'LabSwitch'; DCEdition = '4'; VMs = @(); InstallSCVMM = 'No'; PullServerDC = $false; Internet = $true; AllowedVLANs = "1-400"; AdditionalNetworksInDC = $true; AdditionalNetworksConfig = @(); EnableGuestServiceInterface = $true }
$LABConfig.AdditionalNetworksConfig += @{
    NetName    = 'HNV';
    NetAddress = '10.103.33.';
    NetVLAN    = '201';
    Subnet     = '255.255.255.0'
}

1..4 | ForEach-Object {
    $VMNames = "HV";
    $LABConfig.VMs += @{
        VMName             = "$VMNames$_";
        Configuration      = 'S2D';
        ParentVHD          = 'Win2019Core_G2.vhdx';
        SSDNumber          = 2;
        SSDSize            = 800GB;
        HDDNumber          = 4;
        HDDSize            = 4TB;
        MemoryStartupBytes = 20GB;
        NestedVirt         = $True;
        StaticMemory       = $True;
        VMProcessorCount   = 6
    }
}

$LABConfig.VMs += @{
    VMName             = "Management";
    Configuration      = 'S2D';
    ParentVHD          = 'Win2019_G2.vhdx';
    SSDNumber          = 1;
    SSDSize            = 50GB;
    MemoryStartupBytes = 4GB;
    NestedVirt         = $false;
    StaticMemory       = $false;
    VMProcessorCount   = 4
}


