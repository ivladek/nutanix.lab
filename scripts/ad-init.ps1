
$LabProjects = 5
$LabUsersPerPorjects = 5
$LabAdminUsers = @( 1 )
$LabPowerUsers = @( 2, 3 )
$LabPassword = "M@rvel4u"
$LabAD = "nutanix.lab"
$LabOU="LAB"
$LabProjectGroups = @( "Admins", "Power Users", "Users" )
$LabPCUser = "LABpc"

Write-Host "Init Active Directory for lab environment" -ForegroundColor Magenta
Write-Host "  Active Directory: $LabAD" -ForegroundColor Magenta
Write-Host "  LAB OU: $LabOU" -ForegroundColor Magenta
Write-Host "  projects: $LabProjects" -ForegroundColor Magenta
Write-Host "  users per project: $LabUsersPerPorjects" -ForegroundColor Magenta

Write-Host "Init Active Directory $LabOU" -ForegroundColor Yellow
$ad = $LabAD -split '\.'
$LabAD_CN = "DC=" + $ad[0] + ",DC=" + $ad[1]
$LabOU_CN = "OU=$LabOU,$LabAD_CN"
Write-Host "  create OU: $LabOU_CN" -ForegroundColor Green
New-ADOrganizationalUnit -Name "$LabOU" -Path "$LabAD_CN"
Write-Host "  create user for Nutanix Prism Central: $LabPCUser" -ForegroundColor Green
New-ADUser `
  -Path "$LabOU_CN" `
  -DisplayName "Nutanix Prism Central" `
  -Name "Nutanix Prism Central" `
  -Surname "Prism Central" `
  -GivenName "Nutanix" `
  -UserPrincipalName "$LabPCUser@$LabAD" `
  -SamAccountName "$LabPCUser" `
  -AccountPassword ( ConvertTo-SecureString -AsPlainText "$LabPassword" -Force ) `
  -ChangePasswordAtLogon $False `
  -PasswordNeverExpires $True `
  -CannotChangePassword $True `
  -Enabled $True

for ( $p = 1; $p -le $LabProjects; $p++ )
{
  Write-Host "Init project # $p" -ForegroundColor Yellow

  $ProjectGroups = @()
  foreach ( $g in $LabProjectGroups )
  {
    $w = $g -split ' '
    $LabGroupFull = "Project $p - $g"
    $LabGroupShort = "project$p-" +$w[0]
    $LabGroupShort = $LabGroupShort.ToLower()
    Write-Host "  create group: ""$LabGroupFull"" ($LabGroupShort)" -ForegroundColor Green
    $ProjectGroups += "$LabGroupShort"
    New-ADGroup `
      -Path "$LabOU_CN" `
      -Name "$LabGroupFull" `
      -DisplayName "$LabGroupFull" `
      -SamAccountName "$LabGroupShort" `
      -GroupScope Global `
      -GroupCategory Security
  }

  for ( $u = 1; $u -le $LabUsersPerPorjects; $u++ )
  {
    $UserLogin="p$p-u$u"
    $UserName="Project $p - User $u"

    Write-Host "  create user: ""$UserName"" ($UserLogin)" -ForegroundColor Green
    New-ADUser `
      -Path "$LabOU_CN" `
      -DisplayName "$UserName" `
      -Name "$UserName" `
      -Surname "Project$p" `
      -GivenName "User$u" `
      -UserPrincipalName "$UserLogin@$LabAD" `
      -SamAccountName "$UserLogin" `
      -AccountPassword (ConvertTo-SecureString -AsPlainText "$LabPassword" -Force ) `
      -ChangePasswordAtLogon $False `
      -PasswordNeverExpires $True `
      -CannotChangePassword $True `
      -Enabled $True

    $NewUser = Get-ADUser -Identity $UserLogin
  
    Write-Host ( "    add to group: " + $ProjectGroups[2] ) -ForegroundColor Green
    Add-ADGroupMember -Identity $ProjectGroups[2] -Members $UserLogin
 
    $NewName = $null
    foreach ( $n in $LabAdminUsers )
    {
      if ( $u -eq $n )
      {
        Write-Host ( "    add to group: " + $ProjectGroups[0] ) -ForegroundColor Green
        Add-ADGroupMember -Identity $ProjectGroups[0] -Members $UserLogin
        $NewName = ( $NewName + "a" )
      }
    }
    
    foreach ( $n in $LabPowerUsers )
    {
      if ( $u -eq $n )
      {
        Write-Host ( "    add to group: " + $ProjectGroups[1] ) -ForegroundColor Green
        Add-ADGroupMember -Identity $ProjectGroups[1] -Members $UserLogin
        $NewName = ( $NewName + "p" )
      }
    }
    if ( $NewName -ne $null )
    {
      $NewName = ( $UserName + $NewName )
      Set-ADUser -Identity $NewUser -DisplayName $NewName
      Rename-ADObject -Identity $NewUser -NewName $NewName
    }
  }
}