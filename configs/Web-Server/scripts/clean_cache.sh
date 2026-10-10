#!/bin/bash

# Перевірка, чи скрипт запущено від імені root
if [ "$EUID" -ne 0 ]; then
  echo "Помилка: Цей скрипт потрібно запускати через sudo або від імені root!"
  exit 1
fi

echo "=== Старт повного очищення кешу: $(date) ==="

# 1. Скидання кешу оперативної пам'яті (RAM Cache)
echo "1. Очищення кешу оперативної пам'яті..."
# sync записує всі дані з буферів на диск перед очищенням
sync
# 3 — очистити PageCache, dentries та inodes
echo 3 > /proc/sys/vm/drop_caches
echo "Кеш пам'яті успішно очищено."

# 2. Очищення кешу пакетного менеджера (APT / DNF)
if [ -x "$(command -v apt-get)" ]; then
    echo "2. Очищення кешу пакетів (APT)..."
    apt-get clean -y
    apt-get autoclean -y
    apt-get autoremove -y
    elif [ -x "$(command -v dnf)" ]; then
    echo "2. Очищення кешу пакетів (DNF)..."
    dnf clean all -y
    dnf autoremove -y
fi

# 3. Очищення застарілих системних логів (journald)
if [ -x "$(command -v journalctl)" ]; then
    echo "3. Очищення логів systemd journal (залишаємо лише за останні 2 дні)..."
    journalctl --vacuum-time=2d
fi

# 4. Очищення кешу ескізів (Thumbnails) поточного користувача
# (Корисно для десктопних версій Linux, на серверах можна пропустити)
echo "4. Очищення кешу ескізів користувачів..."
rm -rf /home/*/.cache/thumbnails/* 2>/dev/null
rm -rf ~/.cache/thumbnails/* 2>/dev/null

echo "=== Очищення успішно завершено! ==="
# Показуємо поточний стан пам'яті
echo "Поточний стан оперативної пам'яті:"
free -h

                               
