# Script to autmate UEFI setting preparation of Lenovo HX nodes for Nutanix Cluster deployment
#
# 06.11.2024
# Vladislav Kirilin
# ivladek@me.com, @ivladek
#

$KBtitle    = 'Recommended UEFI settings for Lenovo ThinkAgile HX systems (3rd gen) - Lenovo ThinkAgile'
$KBurl       = 'https://support.lenovo.com/us/en/solutions/ht512850-recommended-uefi-settings-for-lenovo-thinkagile-hx-systems-3rd-gen-lenovo-thinkagile'
$Platform    = 'Lenovo HX3331, 3rd Gen, Type 7D52'
$XCCsettings = [ordered]@{
     'SystemRecovery.F1StartControl'             = 'Text Setup'      
     'BootModes.SystemBootMode'                  = 'UEFI Mode'
     'BootOrder.BootOrder'                       = 'CD/DVD Rom=Hard Disk'
     'OperatingModes.ChooseOperatingMode'        = 'Custom Mode'
     'Memory.MemorySpeed'                        = 'Maximum Performance'
     'Memory.MemoryPowerManagement'              = 'Disabled'
     'Processors.CPUPstateControl'               = 'none'
     'Processors.CStates'                        = 'Disabled'
     'Processors.C1EnhancedMode'                 = 'Disabled'
     'Processors.UPILinkFrequency'               = 'Maximum Performance'
     'Processors.UPILinkDisable'                 = 'Enabled All Links'
     'Processors.TurboMode'                      = 'Enabled'
     'Processors.EnergyEfficientTurbo'           = 'Disabled'
     'Power.PowerPerformanceBias'                = 'Platform Controlled'
     'Power.PlatformControlledType'              = 'Maximum Performance'
     'Memory.PagePolicy'                         = 'Adaptive'
     'processors.monitormwait'                   = 'Enabled'
     'DevicesandIOPorts.EnableDisableIntelVMD'   = 'Enabled'
     'DevicesandIOPorts.VMDforDirectAssign'      = 'Enabled'
}
$XCCcli      = 'G:\nutanix\lenovo\onecli\OneCLI.exe'
$XCCuser     = 'USERID'
$XCCpassword = 'HyperApp@2024'
$XCCip       = @( 
     '100.64.11.111'
     '100.64.11.112'
     '100.64.11.113'
)

# execute Lenovo onecli command
function XCCcmd {
     param (
          [string]$CMDstring
     )
     Invoke-Expression ( $XCCcli + ' ' + $CMDstring +' --bmc ' + $XCCuser + ':"' + $XCCpassword + '"@' + $h )
}

Write-Host ( $KBtitle ) -ForegroundColor Cyan
Write-Host ( $Platform ) -ForegroundColor Cyan

Write-Host ( "`n`nReset to defaults" ) -ForegroundColor Green
foreach ($h in $XCCip) {
     Write-Host ( "`nXCC host: $h" ) -ForegroundColor Yellow
     XCCcmd 'ospower boottosetup'
     XCCcmd 'config loaddefault BootOrder'
     XCCcmd 'config loaddefault UEFI'
     XCCcmd 'ospower reboot'
}

Write-Host ( "`n`nSet UEFI settings" ) -ForegroundColor Green
foreach ($h in $XCCip) {
     Write-Host ( "`nXCC host: $h" ) -ForegroundColor Yellow
     XCCcmd 'ospower boottosetup'
     foreach ($s in $XCCsettings.keys) {
          XCCcmd ('config set ' + $s + ' "' + $XCCsettings[$s] + '"')
     }
     XCCcmd 'ospower reboot'
}

Write-Host ( "`n`nCheck UEFI settings and power off" ) -ForegroundColor Green
foreach ($h in $XCCip) {
     Write-Host ( "`nXCC host: $h" ) -ForegroundColor Yellow
     foreach ($s in $XCCsettings.keys) {
          XCCcmd ('config show ' + $s)
          Write-Host ( $s + '=' + $XCCsettings[$s] + '  << expected' ) -ForegroundColor Gray
     }
     XCCcmd 'ospower poweroff'
}
