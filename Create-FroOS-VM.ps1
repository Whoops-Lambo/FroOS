param(
  [Parameter(Mandatory=$true)]
  [string]$IsoPath,
  [string]$VmName = "FroOS",
  [int]$MemoryMB = 4096,
  [int]$CpuCount = 2,
  [int]$DiskGB = 24
)
$ErrorActionPreference = "Stop"
$VBox = (Get-Command "VBoxManage.exe" -ErrorAction SilentlyContinue).Source
if (-not $VBox) {
  $candidate = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe"
  if (Test-Path $candidate) { $VBox = $candidate }
}
if (-not $VBox) {
  Write-Host "VirtualBox was not found. Install it first from https://www.virtualbox.org/wiki/Downloads" -ForegroundColor Red
  exit 1
}
if (-not (Test-Path $IsoPath)) { throw "ISO not found: $IsoPath" }
$IsoPath = (Resolve-Path $IsoPath).Path
& $VBox list vms | Out-String | ForEach-Object {
  if ($_ -match ('"' + [regex]::Escape($VmName) + '"')) { throw "A VM named '$VmName' already exists. Remove or rename it in VirtualBox first." }
}
$DiskPath = Join-Path $env:USERPROFILE ("VirtualBox VMs\" + $VmName + "\" + $VmName + ".vdi")
& $VBox createvm --name $VmName --ostype Debian_64 --register
& $VBox modifyvm $VmName --memory $MemoryMB --cpus $CpuCount --vram 128 --graphicscontroller vmsvga --boot1 dvd --boot2 disk --audio-enabled off
& $VBox createmedium disk --filename $DiskPath --size ([int]($DiskGB * 1024)) --format VDI
& $VBox storagectl $VmName --name "SATA" --add sata --controller IntelAhci
& $VBox storageattach $VmName --storagectl "SATA" --port 0 --device 0 --type hdd --medium $DiskPath
& $VBox storagectl $VmName --name "IDE" --add ide
& $VBox storageattach $VmName --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium $IsoPath
if ($LASTEXITCODE -ne 0) { throw "VirtualBox command failed. Check VirtualBox installation and ISO path." }
Write-Host "FroOS VM created. Open VirtualBox and start '$VmName'." -ForegroundColor Green
