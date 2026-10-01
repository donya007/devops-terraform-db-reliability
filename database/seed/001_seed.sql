-- ============================================================
-- Hotel Booking Seed Data
-- Creates 120 bookings across multiple orgs, hotels, cities
-- and statuses, plus booking events.
-- ============================================================

-- ------------------------------------------------------------
-- Seed 120 hotel bookings
-- ------------------------------------------------------------

INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    (
        ARRAY[
            '11111111-1111-1111-1111-111111111111',
            '22222222-2222-2222-2222-222222222222',
            '33333333-3333-3333-3333-333333333333',
            '44444444-4444-4444-4444-444444444444'
        ]::uuid[]
    )[1 + ((n - 1) % 4)],
    'HOTEL-' || LPAD(((n - 1) % 12 + 1)::text, 3, '0'),
    (
        ARRAY[
            'delhi',
            'mumbai',
            'bangalore',
            'hyderabad',
            'pune',
            'chennai'
        ]
    )[1 + ((n - 1) % 6)],
    CURRENT_DATE + ((n % 30) + 1),
    CURRENT_DATE + ((n % 30) + 4),
    (2500 + (n * 175))::numeric(12,2),
    (
        ARRAY[
            'confirmed',
            'pending',
            'cancelled',
            'completed'
        ]
    )[1 + ((n - 1) % 4)],
    NOW() - ((n % 60) || ' days')::interval
FROM generate_series(1, 120) AS n;


-- ------------------------------------------------------------
-- BOOKING_CREATED event for every booking
-- ------------------------------------------------------------

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKING_CREATED',
    jsonb_build_object(
        'source', 'seed',
        'message', 'Booking created'
    ),
    created_at
FROM hotel_bookings;


-- ------------------------------------------------------------
-- BOOKING_CONFIRMED events
-- ------------------------------------------------------------

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKING_CONFIRMED',
    jsonb_build_object(
        'source', 'seed',
        'message', 'Booking confirmed'
    ),
    created_at + INTERVAL '1 hour'
FROM hotel_bookings
WHERE status = 'confirmed';


-- ------------------------------------------------------------
-- BOOKING_CANCELLED events
-- ------------------------------------------------------------

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKING_CANCELLED',
    jsonb_build_object(
        'source', 'seed',
        'message', 'Booking cancelled'
    ),
    created_at + INTERVAL '2 hours'
FROM hotel_bookings
WHERE status = 'cancelled';
