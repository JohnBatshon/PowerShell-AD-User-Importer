# ----- Variables Used ----- #
# Adjust the password as needed. 
$user_password = "Password1?"
# Text file with First & Last names.
# Format: First Last
$user_list = .\usernames.txt
# --------------------------- #

$password = ConvertTo-SecureString $user_password -AsPlainText -Force
New-ADOrganizationalUnit -Name _Users_ -ProtectedFromAccidentalDeletion $false

foreach ($name in $user_list) {
    $first = $name.Split(" ")[0].ToLower()
    $last = $name.Split(" ")[1].ToLower()
    $username = "$(first.Substring(0,1))$last").ToLower()
    Write-Host "Creating user: ($username)" -BackgroundColor Black -ForegroundColor Yellow

    New-AdUser -AccountPassword $password `
                -GivenName $first `
                -Surname $last `
                -DisplayName $username `
                -Name $username `
                -EmployeeID $username `
                -PasswordNeverExpires $false `
                -Path "ou=_Users_,$(([ADSI]`"").distinguisedName)" `
                -Enabled $true
}