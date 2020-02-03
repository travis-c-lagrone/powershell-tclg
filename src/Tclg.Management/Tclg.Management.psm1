$sources = @(
    'Item/Hide-Item.ps1'
    'Item/Lock-Item.ps1'
    'Item/Show-Item.ps1'
    'Item/Unlock-Item.ps1'
)

foreach ($path in $sources) {
    . (Join-Path $PSScriptRoot $path)
}
