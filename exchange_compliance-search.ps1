### DO NOT AUTORUN!
### Run each command separate. 


# Search and Purch Variable Setup
$newSearchName = 'PhishingEmail-060420'
$newSearchDescription = 'Searching phishing email investigation'
$SearchSenderEmail = 'badguy@bg.net'
$SearchEmailDate = '2020-06-04'


# Create credential object
$credentials = Get-Credential


# Configure a remote session to the Exchange Compliance & Security
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid -Credential $credentials -Authentication Basic -AllowRedirection

#Connect session and Import Commands (you have to run this to get the 'New-ComplianceSearch' commands) 
Import-PSSession $session -AllowClobber -DisableNameChecking 

# Create a search query  (-Name & -Description will show up in the 0365 compliance center search results)
New-ComplianceSearch -Name $newSearchName -Description $newSearchDescription -ExchangeLocation 'All' -ContentMatchQuery '(c:c)(sent>$($SearchEmailDate))(from=$($SearchSenderEmail))'
# Start Search
Start-ComplianceSearch -Identity $newSearchName

# Returns Status of search
Get-ComplianceSearch -Identity $newSearchName

# Returns number of results returned from search
Get-ComplianceSearch -Identity $newSearchName | Format-List -Property Items



#Preview the results
New-ComplianceSearchAction -SearchName $newSearchName -Preview
Get-ComplianceSearchAction -Identity $newSearchName'_Preview' | Select-Object -Property Results
 
# Just to export results to a file
Get-ComplianceSearchAction -Identity $newSearchName'_Preview' | Format-List -Property Results | Out-File  c:\$newSearchName.txt

# Purge the Emails (softDelete or hardDelete)
New-ComplianceSearchAction -SearchName $newSearchName  -Purge -PurgeType SoftDelete
Get-ComplianceSearchAction -Identity $newSearchName'_Purge'

# Exports purge results to a file
Get-ComplianceSearchAction -Identity $newSearchName'_Purge' | Format-List -Property Results| Out-File  c:\$newSearchName'_purged.txt'

# IMPORTANT! Close the session
Remove-PSSession $session
