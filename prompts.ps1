# Tadrian Davis 011332686

try {
    
}
catch {
    #alerts user if they're out of memory
    [System.OutOfMemoryException]
    Write-Host "Out of memory. Please close some programs to continue."; 
}
#continue script
finally {
#while loop to cycle through user's input options

#create C:\Users\LabAdmin\Downloads\Requirements1\DailyLog.txt and C:\Users\LabAdmin\Downloads\Requirements1\C916contents.txt
New-Item -Path C:\Users\LabAdmin\Downloads\Requirements1\DailyLog.txt -ItemType File -Force
New-Item -Path C:\Users\LabAdmin\Downloads\Requirements1\C916contents.txt -ItemType File -Force

while(1 -ne 100) {
    switch (Read-Host "(1. to list files) (2. list files in tabular) (3. list CPU and RAM usage) (4. list processes) (5. exit)")
    {
        #lists folder contents and appends to DailyLog.txt
        1 {Get-Date >> C:\Users\LabAdmin\Downloads\Requirements1\DailyLog.txt; Get-ChildItem C:\Users\LabAdmin\Downloads\Requirements1\*.log >> C:\Users\LabAdmin\Downloads\Requirements1\DailyLog.txt; echo "file created"}
        #lists folder contents in tabular format and appends to C916contents.txt
        2 {Get-ChildItem C:\Users\LabAdmin\Downloads\Requirements1 | Sort-Object Name -Descending | Format-Table > C:\Users\LabAdmin\Downloads\Requirements1\C916contents.txt; echo "file created"}
        #lists CPU and RAM usage
        3 {Get-Counter '\Memory\Available MBytes'; Get-Counter '\Processor(_Total)\% Processor Time'}
        #lists processes and sorts as grid
        4 {Get-Process | Select-Object Handles, NonpagedSystemMemorySize, PM, WS, CPU, Id, ProcessName, VirtualMemorySize | Sort-Object VirtualMemorySize | Format-Table }
        #exits script
        5 {"You have exited."; exit}
    }
}
}
