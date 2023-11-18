# Tadrian Davis 011332686
#remove sqlps module if it exists and import sqlserver module
try{
    if (Get-Module -name sqlps) { Remove-Module sqlps }
Import-Module -Name SqlServer

#check if database exists
$dbStatus = Get-SqlDatabase -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" -Name "ClientDB" -ErrorAction SilentlyContinue
#set sql server instance name
$sqlServerInstanceName = "SRV19-PRIMARY\SQLEXPRESS"

#check if database exists and delete if it does
if ($dbStatus -eq $null) {
    Write-Host "The database does not exist."
} else {
    Write-Host "The database exists. Deleting database..."
    #disconnect users from database
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "ALTER DATABASE [ClientDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "DROP DATABASE [ClientDB]"
    Write-Host "The database has been deleted."
}

#create server object and database object
$sqlServerObject = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $sqlServerInstanceName
$databaseName = 'ClientDB'
$databaseObject = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $sqlServerObject, $databaseName

#create database
$databaseObject.Create()
Write-Host "Database has been created"

#create table
Invoke-Sqlcmd –ServerInstance $sqlServerInstanceName -Database $databaseName -InputFile C:\Users\LabAdmin\Downloads\Requirements2\createTable.sql
Write-Host "Client_A_Contacts Table has been created"

#import csv file into table
$Insert = "INSERT INTO [Client_A_Contacts] (first_name, last_name, city, county, zip, officePhone, mobilePhone) "
$Client_A_Contacts = Import-Csv -Path C:\Users\LabAdmin\Downloads\Requirements2\NewClientData.csv

#loop through each row in csv file and insert into table
ForEach($newCustomer in $Client_A_Contacts)
{
    $Values = "VALUES (
                    '$($newCustomer.first_name)', 
                    '$($newCustomer.last_name)',
                    '$($newCustomer.city)',
                    '$($newCustomer.county)',
                    '$($newCustomer.zip)',
                    '$($newCustomer.officePhone)',
                    '$($newCustomer.mobilePhone)')"

    $query = $Insert + $Values
    Invoke-Sqlcmd -Database $databaseName -ServerInstance $sqlServerInstanceName -Query $query
}
#error handling
}catch {
    Write-Output "Error: $($_.Exception.Message)"
    Write-Output "Please contact the developer for assistance"
}

#export table to text file
Invoke-Sqlcmd -Database ClientDB –ServerInstance .\SQLEXPRESS -Query ‘SELECT * FROM dbo.Client_A_Contacts’ > .\SqlResults.txt
