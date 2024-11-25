# workspace/scripts/run-app.sh
#!/bin/bash

APP_NAME=$1
APP_DIR="/workspace_data/${APP_NAME}"
APP_TYPE=$(detect_app_type "${APP_DIR}")

function detect_app_type() {
    local dir=$1
    if [ -f "${dir}/package.json" ]; then
        if grep -q '"next"' "${dir}/package.json"; then
            echo "nextjs"
        elif grep -q '"nest"' "${dir}/package.json"; then
            echo "nestjs"
        else
            echo "nodejs"
        fi
    elif [ -f "${dir}/composer.json" ]; then
        echo "php"
    elif [ -f "${dir}/requirements.txt" ]; then
        echo "python"
    elif [ -f "${dir}/pom.xml" ]; then
        echo "java"
    elif [ -f "${dir}/go.mod" ]; then
        echo "go"
    elif [ -f "${dir}/pubspec.yaml" ]; then
        echo "flutter"
    else
        echo "unknown"
    fi
}

case $APP_TYPE in
    "nextjs"|"nodejs")
        cd "${APP_DIR}" && npm install && npm run build && npm start
        ;;
    "nestjs")
        cd "${APP_DIR}" && npm install && npm run build && npm run start:prod
        ;;
    "php")
        cd "${APP_DIR}" && composer install && php artisan serve
        ;;
    "python")
        cd "${APP_DIR}" && pip install -r requirements.txt && python main.py
        ;;
    "java")
        cd "${APP_DIR}" && ./mvnw package && java -jar target/*.jar
        ;;
    "go")
        cd "${APP_DIR}" && go build -o app && ./app
        ;;
    "flutter")
        cd "${APP_DIR}" && flutter build web && python -m http.server 8000
        ;;
    *)
        echo "Unknown app type"
        exit 1
        ;;
esac