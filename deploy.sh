#!/bin/bash
set -e

APP_NAME=$1

if [ -z "$APP_NAME" ]; then
    echo "Usage: ./deploy.sh <app-name>"
    exit 1
fi

APP_DIR="$HOME/mini-paas/$APP_NAME"
LOG_DIR="$HOME/mini-paas/logs/$APP_NAME"

if [ ! -d "$APP_DIR" ]; then
    echo "Error: app directory '$APP_DIR' does not exist."
    exit 1
fi

mkdir -p "$LOG_DIR"

# Find first free port from 8000-9000
PORT=$(comm -23 \
    <(seq 8000 9000 | sort) \
    <(ss -tuln | awk 'NR>1 {gsub(".*:","",$5); print $5}' | sort -u) \
    | head -n 1)

if [ -z "$PORT" ]; then
    echo "Error: no free port found between 8000 and 9000."
    exit 1
fi

echo "Selected port: $PORT"
echo "Building image: $APP_NAME:latest"

docker build -t "$APP_NAME:latest" "$APP_DIR"

echo "Removing old container if it exists..."
docker rm -f "$APP_NAME" 2>/dev/null || true

echo "Starting container..."
docker run -d \
  --name "$APP_NAME" \
  --restart unless-stopped \
  -p "$PORT:80" \
  -v "$LOG_DIR:/var/log/nginx" \
  "$APP_NAME:latest"

echo "Writing NGINX config..."
sudo tee "/etc/nginx/sites-available/$APP_NAME" > /dev/null <<EOF
server {
    listen 80;
    server_name $APP_NAME.local;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

sudo ln -sf "/etc/nginx/sites-available/$APP_NAME" "/etc/nginx/sites-enabled/$APP_NAME"

echo "Testing NGINX config..."
sudo nginx -t

echo "Reloading NGINX..."
sudo systemctl reload nginx

echo
echo "Deployment complete."
echo "App: $APP_NAME"
echo "URL: http://$APP_NAME.local"
echo "Port: $PORT"
echo "Logs: $LOG_DIR"
