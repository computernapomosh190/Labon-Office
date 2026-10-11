# Видалення файлів із системної папки Temp
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Отримання списку профілів усіх користувачів системи
$UserProfiles = Get-ChildItem -Path "C:\Users" -Directory

# Цикл для очищення локального кешу кожного користувача
foreach ($Profile in $UserProfiles) {
    $TempPath = "$($Profile.FullName)\AppData\Local\Temp\*"
    Remove-Item -Path $TempPath -Recurse -Force -ErrorAction SilentlyContinue
}

# Очищення кошика Windows без запиту підтвердження
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
