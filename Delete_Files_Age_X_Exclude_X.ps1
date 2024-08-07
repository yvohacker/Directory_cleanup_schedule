##################################################################################
# Powershell Script
# Description:
# Empty folder for regular cleaning routine.
# Ignore certain files and only delete them once they reach a certain age.
# Easy Maintainable written.
##################################################################################

### Filter out protected files -> Filter for old files -> Delete filtered files ###

# Base directory from which the files and folders are to be deleted.
$basePath = "X:\Example" ### Change this path

# Files that are not to be deleted.
$excludeDirs = @("Folder1","File1.exe") ### Change this

# Retrieve current date.
$currentDate = Get-Date

# Time frame in days within all files are protected.
$timeframe_delete_protection = 60 ### Change the day count


# Retrieve all files in the directory -> exclude protected files.
$all_files_exept_excluded = Get-ChildItem -Path $basePath -Force |
    Where-Object { -not ($excludeDirs -contains $_.Name) } |
    Select-Object Name,FullName,lastwritetime

# Write-Output $all_files_exept_excluded

# Filter files that are older than X days.
$old_files = $all_files_exept_excluded | Where-Object {
    ($currentDate - $_.LastWriteTime).Days -gt $timeframe_delete_protection
}

# Write-Output $old_files

# Delete files that are included and too old.
$old_files | ForEach-Object {
    Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue #-WhatIf # Remove `-WhatIf` after testing
}
