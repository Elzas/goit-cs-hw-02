#!/bin/bash

# Напишіть скрипт, який автоматично перевіряє, чи доступні
# певні вебсайти. Скрипт повинен використовувати команду
# curl для надсилання HTTP GET запитів до кожного сайту
# у списку та перевірки відповіді.

LOG_FILE="website_status.log"

WEBSITES_ARRAY=(
    "https://google.com"
    "https://facebook.com"
    "https://twitter.com"
    "https://example.invalid"
    "https://httpbin.org/status/404"
    "https://httpbin.org/status/500"
)

: > "$LOG_FILE"    # Очищуємо файл логів перед новим запуском

# Перевіряємо кожен сайт зі списку
for SITE in "${WEBSITES_ARRAY[@]}"; do
    # -s               - тихий режим (без прогрес-бару)
    # -o /dev/null     - не виводити тіло відповіді
    # -w "%{http_code}" - вивести лише HTTP статус-код
    # -L               - слідувати за переадресаціями (301/302 тощо)
    # --max-time 10    - обмеження часу очікування відповіді
    STATUS_CODE=$(curl \
        -s \
        -o /dev/null \
        -w "%{http_code}" \
        -L \
        --max-time 10 \
        "$SITE")

    if [ "$STATUS_CODE" = "200" ]; then
        RESULT="$SITE is UP"
    else
        RESULT="$SITE is DOWN"
    fi

    echo "$RESULT"
    echo "$RESULT" >> "$LOG_FILE"
done

echo "Результати перевірки записано у файл логів: $LOG_FILE"
