# Specify the path to the text file containing usernames (one username per line)
$userListFilePath = "C:\Path\To\usernames.txt"

# Get the Active Directory "Users" group object
$group = Get-ADGroup "Users" -Server "YourDomain"

if ($group -eq $null) {
    Write-Host "Group 'Users' not found in Active Directory."
    exit
}

# Read usernames from the text file
$usernames = Get-Content $userListFilePath

# Loop through each username and add them to the group
foreach ($username in $usernames) {
    # Check if the user exists
    $user = Get-ADUser $username -ErrorAction SilentlyContinue -Server "YourDomain"

    if ($user -eq $null) {
        Write-Host "User '$username' not found in Active Directory."
    } else {
        # Add the user to the group
        Add-ADGroupMember -Identity $group -Members $user -ErrorAction SilentlyContinue
        if ($?) {
            Write-Host "User '$username' added to 'Users' group."
        } else {
            Write-Host "Failed to add user '$username' to 'Users' group."
        }
    }
}