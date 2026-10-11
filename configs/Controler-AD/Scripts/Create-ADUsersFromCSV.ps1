Import-Module ActiveDirectory

# Завантаження бази нових співробітників
\$Users = Import-Csv -Path "C:\Scripts\new_employees.csv"

foreach (\$User in \(Users) {\)Password = ConvertTo-SecureString "CorpPassword2026!" -AsPlainText -Force
    
    # Створення користувача у відповідному відділі (OU)
    New-ADUser -Name \$User.Name `
               -SamAccountName $User.Username `
               -UserPrincipalName "(User.Username)@yourdomain.local" `
               -Path "OU=$($User.Department),OU=Company_Root,DC=yourdomain,DC=local" `
               -AccountPassword \$Password `
               -ChangePasswordAtLogon $true `
               -Enabled \$true
}
