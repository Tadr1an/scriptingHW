# Tadrian Davis 011332686

#unzips Requirements1
Expand-Archive "C:\Users\LabAdmin\Desktop\Requirements1.zip" "C:\Users\LabAdmin\Desktop\Requirements1"

#declares user input variable
$userInput = 0

while($userInput -ne 5) {
    switch (Read-Host "(1. to list files) (2. list files in tabular) (3. list CPU and RAM usage) (4. list processes) (5. exit)")
    {
        1 {Get-Date; Get-ChildItem C:\Users\LabAdmin\Desktop\Requirements1\*.log >> C:\Users\LabAdmin\Desktop\Requirements1\DailyLog.txt}
        2 {Get-ChildItem C:\Users\LabAdmin\Desktop\Requirements1 | Sort-Object Name -Descending | Format-Table > C:\Users\LabAdmin\Desktop\Requirements1\C916contents.txt}
        3 {Get-Counter '\Memory\Available MBytes'; Get-Counter '\Processor(_Total)\% Processor Time'}
        4 {Get-Process | Sort-Object WS | Format-Table }
        5 {"You have exited."; break}
    }
