param (
    [string]$UserListFilePath = "UserList.txt",
    [string]$Domain = "contoso",
    [string]$FullDomain = "contoso.com"
)

# Load Active Directory module
Import-Module ActiveDirectory

# Read usernames from the text file
$userNames = Get-Content $UserListFilePath

foreach ($userName in $userNames) {
    # Check if the user exists in Active Directory
    $user = Get-ADUser $userName -Server $FullDomain -ErrorAction SilentlyContinue

    if ($user -eq $null) {
        Write-Host "User '$userName' not found in Active Directory. Creating user..."
        
        # Create the user
        $password = ConvertTo-SecureString "DefaultPassword123" -AsPlainText -Force
        $userParams = @{
            Name = $userName
            SamAccountName = $userName
            UserPrincipalName = "$userName@$FullDomain"
            AccountPassword = $password
            Enabled = $true
            Path = "OU=Users,DC=$Domain,DC=com"
        }
        New-ADUser @userParams
    }
    else {
        Write-Host "User '$userName' already exists in Active Directory."
    }
}