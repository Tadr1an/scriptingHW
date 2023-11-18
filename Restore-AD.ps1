# Tadrian Davis 011332686

# Get the Finance OU
$finance = Get-ADOrganizationalUnit -Filter {Name -eq "Finance"}

# Deletes the Finance OU if it exists
if ($finance -ne $null) {
    # Gets all users in the Finance OU
    $users = Get-ADUser -Filter * -SearchBase $finance.DistinguishedName

    # Deletes each user
    foreach ($user in $users) {
        Remove-ADUser -Identity $user.SamAccountName -Confirm:$false
    }

    # Deletes the OU
    Remove-ADOrganizationalUnit -Identity $finance.DistinguishedName -Confirm:$false

    Write-Output "Finance OU and all its contents have been deleted."
} else {
    Write-Output "Finance OU does not exist."
}

#creates the Finance OU
New-ADOrganizationalUnit -Name "Finance" -Path "DC=consultingfirm,DC=COM" -ProtectedFromAccidentalDeletion $False
Write-Output "Finance OU has been created."

#imports the csv file containing the finance users
$NewADUsers = Import-Csv -Path "C:\Users\LabAdmin\Desktop\Requirements2\financePersonnel.csv"

#defines the path for the Finance OU
$path = "OU=Finance,DC=consultingfirm,DC=COM"
#assigns the variables to the csv file columns
foreach ($newUser in $NewADUsers)
{
    $firstName = $newUser.First_Name
    $lastName = $newUser.Last_Name
    $displayName = $firstName + " " + $lastName
    $postalCode = $newUser.PostalCode
    $officePhone = $newUser.OfficePhone
    $mobilePhone = $newUser.MobilePhone
#creates the new users in the Finance OU
    New-ADUser  -Name $displayName `
                -GivenName $firstName `
                -Surname $lastName `
                -DisplayName $displayName `
                -PostalCode $postalCode `
                -OfficePhone $officePhone `
                -MobilePhone $mobilePhone `
                -Path $path `

}

#creates the AdResults.txt file
Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt
