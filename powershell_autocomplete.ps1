$scriptBlock = {
    # The parameters passed into the script block by the
    #  Register-ArgumentCompleter command
    param(
        $commandName, $parameterName, $wordToComplete,
        $commandAst, $fakeBoundParameters
    )

    # The list of values that the typed text is compared to
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
    $values = $names -join "`n"

    foreach ($val in $values) {
        # What has been typed matches the value from the list
        if ($val -like "$wordToComplete*") {
            # Print the value
            $val
        }
    }
}