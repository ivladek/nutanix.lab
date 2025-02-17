
# Get Python from https://www.python.org/downloads/windows
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe" -OutFile "%USERPROFILE\Downloads\python-installer.exe"

Write-Host "Set Firewall Rules"
netsh advfirewall firewall add rule name=\"WinRM-HTTPS\" dir=in localport=5986  protocol=TCP action=allow
netsh advfirewall firewall add rule name=\"VSS\"         dir=in localport=23578 protocol=TCP action=allow

Write-Host "Prepare for Nutanix Guest Tools"
$certificate = New-SelfSignedCertificate -DnsName $env:computername -CertStoreLocation cert:\LocalMachine\My
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$env:computername`";CertificateThumbprint=`"$($certificate.ThumbPrint)`"}"
cmd /c 'winrm set winrm/config/service/auth @{Basic="true"}'
