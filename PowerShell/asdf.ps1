try {
    Throw [System.IO.FileNotFoundException]::new()
}
catch {
    $_ | ConvertTo-Json -Depth 100
}