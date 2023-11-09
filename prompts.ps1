# Tadrian Davis 011332686
Expand-Archive "C:\Users\LabAdmin\Desktop\Requirements1.zip" "C:\Users\LabAdmin\Desktop\Requirements1"

New-Item C:\Users\LabAdmin\Desktop\Requirements1\DailyLog.txt

switch (Read-Host "Select a number 1-4. Enter 5 to quit.") {
    1 { date
    ls C:\Users\LabAdmin\Desktop\Requirements1\*.log >> C:\Users\LabAdmin\Desktop\Requirements1\DailyLog.txt}
    2
    3
    4
    5
}
