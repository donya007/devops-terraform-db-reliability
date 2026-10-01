#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="hotel-booking-postgres"
DB_USER="postgres"
RESTORE_DB="hoteldb_restore"
RESTORE_FILE="/tmp/restore.dump"

# Usage:
# ./scripts/restore.sh backup/hoteldb_YYYYMMDD_HHMMSS.dump

if [ $# -ge 1 ]; then
    BACKUP_FILE="$1"
else
    BACKUP_FILE=$(find ./backup -maxdepth 1 -name "*.dump" -type f | sort | tail -1)
fi

if [ -z "${BACKUP_FILE}" ] || [ ! -f "${BACKUP_FILE}" ]; then
    echo "ERROR: Backup file not found."
    exit 1
fi

if ! docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null | grep -q true; then
    echo "ERROR: PostgreSQL container is not running."
    exit 1
fi

echo "========================================"
echo "Database Restore"
echo "========================================"
echo "Backup : ${BACKUP_FILE}"
echo "Target : ${RESTORE_DB}"
echo ""

# Drop old restore database if it exists
echo "Dropping existing restore database..."
docker exec "${CONTAINER_NAME}" \
    psql -U "${DB_USER}" -d postgres \
    -c "DROP DATABASE IF EXISTS ${RESTORE_DB};"

# Create fresh restore database
echo "Creating fresh restore database..."
docker exec "${CONTAINER_NAME}" \
    psql -U "${DB_USER}" -d postgres \
    -c "CREATE DATABASE ${RESTORE_DB};"

# Copy backup into PostgreSQL container
echo "Copying backup into container..."
docker cp "${BACKUP_FILE}" "${CONTAINER_NAME}:${RESTORE_FILE}"

# Restore backup
echo "Restoring backup..."
docker exec "${CONTAINER_NAME}" \
    pg_restore \
    -U "${DB_USER}" \
    -d "${RESTORE_DB}" \
    --no-owner \
    --exit-on-error \
    "${RESTORE_FILE}"

# Remove temporary backup from container
docker exec "${CONTAINER_NAME}" rm -f "${RESTORE_FILE}"

echo ""
echo "========================================"
echo "Restore completed successfully!"
echo "Database: ${RESTORE_DB}"
echo "========================================"
