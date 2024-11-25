#!/bin/bash
# workspace/deploy.sh

detect_project_type() {
    if [ -f "package.json" ]; then
        if grep -q "\"next\":" "package.json"; then
            echo "nextjs"
        elif grep -q "\"nest\":" "package.json"; then
            echo "nestjs"
        else
            echo "nodejs"
        fi
    elif [ -f "composer.json" ]; then
        echo "php"
    elif [ -f "requirements.txt" ]; then
        echo "python"
    elif [ -f "go.mod" ]; then
        echo "go"
    elif [ -f "pubspec.yaml" ]; then
        echo "flutter"
    else
        echo "unknown"
    fi
}

deploy_app() {
    PROJECT_TYPE=$(detect_project_type)
    
    case $PROJECT_TYPE in
        "nextjs")
            npm install
            npm run build
            npm run start
            ;;
        "nestjs")
            npm install
            npm run build
            npm run start:prod
            ;;
        "nodejs")
            npm install
            npm start
            ;;
        "php")
            composer install
            php-fpm
            ;;
        "python")
            pip3 install -r requirements.txt
            python3 app.py
            ;;
        "go")
            go build
            ./main
            ;;
        "flutter")
            flutter pub get
            flutter build web
            ;;
        *)
            echo "Unknown project type"
            exit 1
            ;;
    esac
}

setup_nginx() {
    # Configure Nginx for the app
    cat > /etc/nginx/sites-available/default << EOF
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

    nginx -g 'daemon off;'
}

# Main deployment process
deploy_app &
setup_nginx