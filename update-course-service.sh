#!/bin/bash
# --- BIEN DUNG CHUNG ---
CONTAINER_NAME="rikkei-course-service"
LOG_FILE="/opt/rikkei/deploy.log"
# --- Mau ANSI + ham in ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok() { echo -e "${GREEN}[OK]${NC} $1";}
info() { echo -e "${YELLOW}[INFO]${NC} $1";}
fail() { echo -e "${RED}[FAIL]${NC} $1";}

# --- 1. Kiem tra container ---
if docker inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
	info "$CONTAINER_NAME dang ton tai, thuc hien xoa..."
	#Ghi log
	docker logs "$CONTAINER_NAME" > "$LOG_FILE" 2>&1
	# Dung container
	if ! docker stop "$CONTAINER_NAME"; then
		fail "Khong the dung container"
		exit 1
	fi
	# Xoa container
	if ! docker rm "$CONTAINER_NAME"; then
		fail "Khong the xoa container"
		exit 1
	fi
	ok "Da dung va xoa container cu"
else
	info "${CONTAINER_NAME} chua ton tai"
fi

# --- 2. Tao container moi ---
if docker run -d --name "$CONTAINER_NAME" -p 8081:80 nginxdemos/hello; then
	ok "Da tao moi container $CONTAINER_NAME"
else
	fail "Khong the tao container moi"
	exit 1
fi

