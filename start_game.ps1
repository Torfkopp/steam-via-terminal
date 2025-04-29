# Return table of found Steam games, or starts the game when only one is found

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Parameter
)

if ($Parameter.Count -eq 0) {
    $SearchName = $null
} else {
    $SearchName = $Parameter -join ' '
}

$paths = @(
    'C:\Steam\steamapps',
    'D:\SteamLibrary\steamapps'
)

$results = @($paths |
ForEach-Object {
    Get-ChildItem -Path $_ -Filter *.acf -File -ErrorAction SilentlyContinue
} |
ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding utf8

    $appid = if ($content -match '"appid"\s+"(\d+)"') { $matches[1] } else { $null }
    $name  = if ($content -match '"name"\s+"(.+?)"') { $matches[1] } else { $null }

    if ($appid -and $name) {
        [PSCustomObject]@{
            AppID = $appid
            Name  = $name
            Path  = $_.DirectoryName
        }
    }
} |
Where-Object { $_.Name -match $SearchName })

if ($results.Count -eq 1) {
    $appid = $results[0].AppID
    Write-Host "Launching $($results[0].Name) (AppID: $appid)..." -ForegroundColor Green
    Start-Process "steam://rungameid/$appid"
}
elseif ($results.Count -gt 1) {
    $results | Sort-Object Name | Format-Table -Property AppID, Name, Path -AutoSize
}
else {
    Write-Warning "No matches found for '$SearchName'."
}
