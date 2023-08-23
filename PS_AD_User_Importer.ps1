# Please ensure you have the Active Directory module loaded by running Import-Module ActiveDirectory before executing the script.
# Replace "YourGroupName" with the actual name of the Active Directory group you want to add users to. 
# Replace "C:\Path\To\UserList.txt" with the path to the text file containing the list of user names.
# Specify the Active Directory group name
$groupName = "YourGroupName"

# Specify the path to the text file containing user names (one username per line)
# Example UserList.txt
# user1
# user2
# john.doe
# jane.smith
$userListFilePath = "C:\Path\To\UserList.txt"

# Get the Active Directory group object
$group = Get-ADGroup $groupName

if ($group -eq $null) {
    Write-Host "Group '$groupName' not found in Active Directory."
    exit
}

# Read user names from the text file
$userNames = Get-Content $userListFilePath

# Loop through each user name and add them to the group
foreach ($userName in $userNames) {
    # Check if the user exists
    $user = Get-ADUser $userName -ErrorAction SilentlyContinue

    if ($user -eq $null) {
        Write-Host "User '$userName' not found in Active Directory. Creating user..."
        
        # Create the user
        $password = ConvertTo-SecureString "DefaultPassword123" -AsPlainText -Force
        New-ADUser -Name $userName -SamAccountName $userName -AccountPassword $password -Enabled $true -Path "OU=Users,DC=YourDomain,DC=com"

        # Fetch the newly created user
        $user = Get-ADUser $userName
    }
    
    # Add the user to the group
    Add-ADGroupMember -Identity $group -Members $user -ErrorAction SilentlyContinue
    
    if ($?) {
        Write-Host "User '$userName' added to group '$groupName'."
    } else {
        Write-Host "Failed to add user '$userName' to group '$groupName'."
    }
}