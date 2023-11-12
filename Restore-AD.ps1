# Tadrian Davis 011332686

#creates variable for the Finance OU
$finance = Get-ADOrganizationalUnit -Filter {Name -eq "Finance"} #creates variable for the Finance OU


#deletes the Finance OU if it exists
if ($finance -ne $null) {
    Write-Output "Finance exists. It will be deleted now."; Remove-ADOrganizationalUnit -Identity "OU=Finance"
} else {
    Write-Output "Finance does not exist."
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
