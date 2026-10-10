#!/bin/bash

# ==========================================
# НАЛАШТУВАННЯ ZABBIX
# ==========================================
ZABBIX_SERVER="192.168.10.4"
ZABBIX_HOST="Labon-Server"
ZABBIX_KEY="log.analysis.status"  # Ключ типу Text або Log у Zabbix

REPORT_FILE="/tmp/zabbix_log_report.txt"
rm -f "$REPORT_FILE"

# 1. Перевірка OOM Killer
OOM_ERRORS=$(journalctl --since "1h" | grep -iE "killed process|out of memory|oom-killer" | tail ->
if [ ! -z "$OOM_ERRORS" ]; then
    echo -e "[CRITICAL] OOM Killer detected:\n$OOM_ERRORS" >> "$REPORT_FILE"
fi

# 2. Перевірка Hardware
HARDWARE_ERRORS=$(dmesg | grep -iE "hardware error|mce:|machine check|io error" | tail -n 5)
if [ ! -z "$HARDWARE_ERRORS" ]; then
    echo -e "[CRITICAL] Hardware Errors:\n$HARDWARE_ERRORS" >> "$REPORT_FILE"
fi

# 3. Перевірка PostgreSQL (системний журнал)
DB_ERRORS=$(journalctl -u postgresql --since "1h" 2>/dev/null | grep -iE "fatal|panic|database sys>
if [ ! -z "$DB_ERRORS" ]; then
    echo -e "[WARNING] DB Critical Errors:\n$DB_ERRORS" >> "$REPORT_FILE"
fi

# ==========================================
# ВІДПРАВКА ДАНИХ
# ==========================================
if [ -f "$REPORT_FILE" ]; then
    # Зчитуємо вміст звіту в змінну для відправки в Zabbix
    LOG_PAYLOAD=$(cat "$REPORT_FILE")
    zabbix_sender -z "$ZABBIX_SERVER" -s "$ZABBIX_HOST" -k "$ZABBIX_KEY" -o "$LOG_PAYLOAD" > /dev/>
else
    # Якщо все чисто — надсилаємо статус OK
    zabbix_sender -z "$ZABBIX_SERVER" -s "$ZABBIX_HOST" -k "$ZABBIX_KEY" -o "OK" > /dev/null
fi

rm -f "$REPORT_FILE"

