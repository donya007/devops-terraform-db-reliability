#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# PostgreSQL Backup Script
# ============================================================

CONTAINER_NAME="hotel-booking-postgres"
DB_NAME="hoteldb"
DB_USER="postgres"

BACKUP_DIR="./backup"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.dump"

# Create backup directory if it does not exist
mkdir -p "${BACKUP_DIR}"

echo "=========================================="
echo " PostgreSQL Database Backup"
echo "=========================================="
echo "Database : ${DB_NAME}"
echo "Container: ${CONTAINER_NAME}"
echo "Output   : ${BACKUP_FILE}"
echo

# Check whether PostgreSQL container is running
if ! docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null | grep -q true; then
    echo "ERROR: PostgreSQL container is not running."
    echo "Run: docker compose up -d"
    exit 1
fi

# Create PostgreSQL custom-format dump
docker exec "${CONTAINER_NAME}" \
    pg_dump \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    -Fc \
    > "${BACKUP_FILE}"

echo
echo "Backup completed successfully."
echo
echo "Backup file:"
echo "${BACKUP_FILE}"

echo
echo "Backup size:"
du -h "${BACKUP_FILE}"

