# Returns a string of all found Steam Games

$paths = @(
    'C:\Steam\steamapps',
    'D:\SteamLibrary\steamapps'
)

$names = $paths |
ForEach-Object {
    Get-ChildItem -Path $_ -Filter *.acf -File -ErrorAction SilentlyContinue
} |
ForEach-Object {
    $name = $null
    $content = Get-Content $_.FullName -Raw -Encoding utf8
    if ($content -match '"name"\s+"(.+?)"') {
        $name = $matches[1]
    }
    if ($name) {
        $name
    }
} | Sort-Object

# Join names with newline separator
$namesString = $names -join "`n"

# Output final result
$namesString