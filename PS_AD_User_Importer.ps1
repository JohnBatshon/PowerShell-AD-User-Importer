# Path to CSV File
$ADUsers = Import-csv C:\Temp\NewUsers.CSV

for each ($user in  $ADUsers)
{

        $Username = $User.username
        $Password = $User.password
        $Firstname = $User.firstname
        $Lastname = $User.lastname
        $Department = $User.department
        $OU = $User.ou

        # Check to see if user account exists in Active Directory
        if (Get-ADUser -F {SamAccountName -eq $Username})
        {
                # If user does exist then output a warning message
                Write-Warning "A user account named $Username already exists within Active Directory"
        }
        else 
        {
                # If the user does not exist then create a new user account
                
        # Account will be created in the OU listed in the $OU variable in the CSV file.
        # Ensure you change the domain name in the "-UserPrincipalName" variable
                New-ADUser `
                -SamAccountName $Username `
                -UserPrincipalName "$username@SecureCo.com" `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $true `
                -ChangePasswordAtLogin $true `
                -DisplayName "$Lastname, $Firstname" `
                -Department $Department `
                -Path $OU `
                -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
                
        }
}