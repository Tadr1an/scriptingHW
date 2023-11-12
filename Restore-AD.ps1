# Tadrian Davis 011332686

$finance = Get-ADOrganizationalUnit -Filter {Name -eq "Finance"}

if ($finance -ne $null) {
    Write-Output "Finance exists. It will be deleted now."; Remove-ADOrganizationalUnit -Identity "OU=Finance"
} else {
    Write-Output "Finance does not exist."
}

New-ADOrganizationalUnit -Name "Finance" -Path "DC=consultingfirm,DC=COM" -ProtectedFromAccidentalDeletion $False

$NewADUsers = Import-Csv -Path "C:\Users\LabAdmin\Desktop\Requirements2\financePersonnel.csv"

$path = "OU=Finance,DC=consultingfirm,DC=COM"
foreach ($newUser in $NewADUsers)
{
    $firstName = $newUser.First_Name
    $lastName = $newUser.Last_Name
    $displayName = $firstName + " " + $lastName
    $postalCode = $newUser.PostalCode
    $officePhone = $newUser.OfficePhone
    $mobilePhone = $newUser.MobilePhone

    New-ADUser  -Name $displayName `
                -GivenName $firstName `
                -Surname $lastName `
                -DisplayName $displayName `
                -PostalCode $postalCode `
                -OfficePhone $officePhone `
                -MobilePhone $mobilePhone `
                -Path $path `

}

Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt
