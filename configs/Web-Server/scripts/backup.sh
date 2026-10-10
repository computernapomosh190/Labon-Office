#!/bin/bash

# ==========================================
# 1. НАЛАШТУВАННЯ (Змініть під власні потреби)
# ==========================================
DB_TYPE="mysql"           # Вкажіть "mysql" або "postgres"
DB_USER="wp_user"
DB_PASS="wp_user123" # Для PostgreSQL краще використовувати файл .pgpass (див. нижче)
DB_NAME="wordpress_db"
DB_HOST="localhost"

BACKUP_DIR="/var/backups/db" # Папка для збереження бекапів
KEEP_DAYS=7                  # Скільки днів зберігати бекапи
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Створення назви файлу
FILE_NAME="${DB_NAME}_${DATE}.sql"
ARCHIVE_NAME="${FILE_NAME}.tar.gz"

# Створення папки для бекапів, якщо вона не існує
mkdir -p "$BACKUP_DIR"

# ==========================================
# 2. СТВОРЕННЯ ДАМПУ ТА АРХІВАЦІЯ
# ==========================================
echo "=== Старт бекапу: $(date) ==="

if [ "$DB_TYPE" = "mysql" ]; then
    echo "Створення дампу MySQL..."
    # Використовуємо mysqldump (пароль вказується без пробілу після -p)
    MYSQL_PWD="${DB_PASS}" mysqldump -h "$DB_HOST" -u "$DB_USER" "$DB_NAME" > "$BACKUP_DIR/$FILE_N>

elif [ "$DB_TYPE" = "postgres" ]; then
    echo "Створення дампу PostgreSQL..."
    # Якщо використовуєте пароль тут, переконайтеся, що налаштовано .pgpass, або передайте через з>
    PGPASSWORD="${DB_PASS}" pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -F p > "$BACKUP_DIR/>
else
    echo "Помилка: Невідомий тип БД (оберіть mysql або postgres)"
    exit 1
fi

# Перевірка, чи створився файл дампу
if [ -s "$BACKUP_DIR/$FILE_NAME" ]; then
    echo "Архівування дампу..."
    tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$BACKUP_DIR" "$FILE_NAME"
# Перевірка, чи створився файл дампу
if [ -s "$BACKUP_DIR/$FILE_NAME" ]; then
    echo "Архівування дампу..."
    tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$BACKUP_DIR" "$FILE_NAME"

    # Видаляємо сирий .sql файл, залишаючи тільки архів .tar.gz
    rm "$BACKUP_DIR/$FILE_NAME"
    echo "Архів створено: $ARCHIVE_NAME"
else
    echo "Помилка: Дамп бази даних не був створений або він порожній!"
    exit 1
fi

# ==========================================
# 3. ОЧИЩЕННЯ СТАРИХ КОПІЙ
# ==========================================
echo "Очищення бекапів, старіших за $KEEP_DAYS днів..."
# Шукаємо файли tar.gz у папці бекапів, які були змінені більше ніж KEEP_DAYS тому, і видаляємо їх
find "$BACKUP_DIR" -type f -name "${DB_NAME}_*.tar.gz" -mtime +"$KEEP_DAYS" -exec rm {} \;

echo "=== Бекап успішно завершено: $(date) ==="



