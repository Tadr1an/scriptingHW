$path = "OU=Finance,DC=consultingfirm,DC=COM"
foreach ($newUser in $NewADUsers)
{
    $firstName = $newUser.FirstName -replace '\W','' # Remove non-alphanumeric characters
    $lastName = $newUser.LastName -replace '\W','' # Remove non-alphanumeric characters
    $displayName = $firstName + " " + $lastName
    $userName = ($firstName + $lastName).Trim() # Create username and remove any leading/trailing spaces
    $postalCode = $newUser.PostalCode
    $officePhone = $newUser.OfficePhone
    $mobilePhone = $newUser.MobilePhone

    New-ADUser  -Name $userName ` # Use the username as the Name
                -GivenName $firstName `
                -Surname $lastName `
                -DisplayName $displayName `
                -PostalCode $postalCode `
                -OfficePhone $officePhone `
                -MobilePhone $mobilePhone `
                -Path $path `

}

Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt
