$NetAddress = "\\192.168.10.3\shared" # IP вашого FTP/файлового сервера
$DriveLetter = "M:"

# Перевірка, чи диск уже не підключений, щоб уникнути помилок
if (-not (Test-Path $DriveLetter)) {
    (New-Object -ComObject WScript.Network).MapNetworkDrive($DriveLetter, $NetAddress, $true)
}
