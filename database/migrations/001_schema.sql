-- ============================================================
-- Hotel Booking Database Schema
-- Migration: 001_schema.sql
-- ============================================================

-- Required for UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;


-- ============================================================
-- Table: hotel_bookings
-- ============================================================

CREATE TABLE IF NOT EXISTS hotel_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    org_id UUID NOT NULL,

    hotel_id VARCHAR(100) NOT NULL,

    city VARCHAR(100) NOT NULL,

    checkin_date DATE NOT NULL,

    checkout_date DATE NOT NULL,

    amount NUMERIC(12,2) NOT NULL,

    status VARCHAR(50) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_booking_dates
        CHECK (checkout_date > checkin_date),

    CONSTRAINT chk_booking_amount
        CHECK (amount >= 0)
);


-- ============================================================
-- Table: booking_events
-- ============================================================

CREATE TABLE IF NOT EXISTS booking_events (
    id BIGSERIAL PRIMARY KEY,

    booking_id UUID NOT NULL,

    event_type VARCHAR(100) NOT NULL,

    payload JSONB,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_events_booking
        FOREIGN KEY (booking_id)
        REFERENCES hotel_bookings(id)
        ON DELETE CASCADE
);


-- ============================================================
-- Index for booking_events lookup by booking
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_booking_events_booking_id
ON booking_events (booking_id);


