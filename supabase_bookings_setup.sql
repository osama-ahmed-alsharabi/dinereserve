-- ============================================
-- Restaurant Booking System - Supabase Schema
-- ============================================

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- User Information
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  user_phone TEXT NOT NULL,
  
  -- Restaurant Information
  restaurant_id TEXT NOT NULL,
  restaurant_name TEXT NOT NULL,
  
  -- Booking Details
  booking_date DATE NOT NULL,
  booking_time TIME NOT NULL,
  table_count INTEGER NOT NULL CHECK (table_count > 0),
  
  -- Payment Information
  payment_method_id TEXT NOT NULL,
  payment_method_name TEXT NOT NULL,
  
  -- Status Management
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'rejected', 'cancelled')),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_restaurant_id ON bookings(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at DESC);

-- Create composite index for restaurant bookings queries
CREATE INDEX IF NOT EXISTS idx_bookings_restaurant_status_date 
ON bookings(restaurant_id, status, booking_date DESC);

-- Enable Row Level Security
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own bookings
CREATE POLICY "Users can view own bookings"
ON bookings FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- Policy: Users can create their own bookings
CREATE POLICY "Users can create own bookings"
ON bookings FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Policy: Users can cancel their own pending bookings
CREATE POLICY "Users can cancel own bookings"
ON bookings FOR UPDATE
TO authenticated
USING (auth.uid() = user_id AND status = 'pending')
WITH CHECK (status = 'cancelled');

-- Policy: Restaurant owners can view bookings for their restaurants
-- Note: This requires a join with restaurant table to verify ownership
-- For now, we'll allow viewing all bookings for restaurants
-- You may need to adjust this based on your auth setup
CREATE POLICY "Restaurant owners can view their bookings"
ON bookings FOR SELECT
TO authenticated
USING (true); -- Adjust based on your restaurant ownership logic

-- Policy: Restaurant owners can update booking status
CREATE POLICY "Restaurant owners can update booking status"
ON bookings FOR UPDATE
TO authenticated
USING (true) -- Adjust based on your restaurant ownership logic
WITH CHECK (status IN ('confirmed', 'rejected'));

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_bookings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function
CREATE TRIGGER update_bookings_updated_at_trigger
BEFORE UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION update_bookings_updated_at();

-- ============================================
-- Sample Queries (for testing)
-- ============================================

-- Get user bookings
-- SELECT * FROM bookings WHERE user_id = 'user-uuid' ORDER BY booking_date DESC;

-- Get restaurant bookings
-- SELECT * FROM bookings WHERE restaurant_id = 'restaurant-id' ORDER BY booking_date DESC;

-- Get pending bookings for a restaurant
-- SELECT * FROM bookings WHERE restaurant_id = 'restaurant-id' AND status = 'pending' ORDER BY created_at DESC;
