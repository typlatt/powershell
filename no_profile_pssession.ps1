$creds = Get-Credential
$options = New-PSSessionOption -nomachineprofile
New-PSSession -ComputerName <TargetComputerName> -Name <SessionName> -SessionOption $options -Credentials $creds
Enter-PSSession -Name <SessionName>
# Do work here on remote computer without leaving a user profile
Disconnect-PSSession -Name <SessionName>
Remove-PSSession -Name <SessionName>
