$ErrorActionPreference = 'Stop'
$object = Join-Path $PSScriptRoot 'plank.o'
$image = Join-Path $PSScriptRoot 'plank.img'

& as --32 -o $object (Join-Path $PSScriptRoot 'plank.s')
if ($LASTEXITCODE -ne 0) { throw 'Assembly failed.' }

& objcopy -O binary -j .text $object $image
if ($LASTEXITCODE -ne 0) { throw 'Image export failed.' }

$bytes = [System.IO.File]::ReadAllBytes($image)
if ($bytes.Length -ne 512 -or $bytes[510] -ne 0x55 -or $bytes[511] -ne 0xaa) {
    throw 'Expected a 512-byte boot sector ending in 55 AA.'
}
Write-Output "Built $image (512 bytes)"
