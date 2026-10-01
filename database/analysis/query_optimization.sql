-- ============================================================
-- Query Optimization Analysis
-- ============================================================

-- Target query
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;


-- Execution plan
EXPLAIN ANALYZE
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;


-- Optimizing index
CREATE INDEX IF NOT EXISTS idx_hotel_bookings_city_created_at
ON hotel_bookings (city, created_at);


-- Execution plan after index
EXPLAIN ANALYZE
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;


-- ============================================================
-- Query optimization index
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_hotel_bookings_city_created_at
ON hotel_bookings (city, created_at);
