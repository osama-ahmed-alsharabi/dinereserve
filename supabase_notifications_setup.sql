-- =====================================================
-- DineReserve Notification System - Database Setup
-- =====================================================
-- Run this script in your Supabase SQL Editor
-- =====================================================

-- Step 1: Create the notifications table
-- =====================================================
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  restaurant_id TEXT NOT NULL,
  restaurant_name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('booking_confirmed', 'booking_rejected')),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 2: Create indexes for performance
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_notifications_user_id 
  ON notifications(user_id);

CREATE INDEX IF NOT EXISTS idx_notifications_created_at 
  ON notifications(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_notifications_is_read 
  ON notifications(is_read);

-- Step 3: Enable Row Level Security (RLS)
-- =====================================================
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS Policies
-- =====================================================
-- Policy: Users can view their own notifications
DROP POLICY IF EXISTS "Users can view their own notifications" ON notifications;
CREATE POLICY "Users can view their own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can update their own notifications (mark as read)
DROP POLICY IF EXISTS "Users can update their own notifications" ON notifications;
CREATE POLICY "Users can update their own notifications"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

-- Step 5: Create automatic notification function
-- =====================================================
CREATE OR REPLACE FUNCTION create_booking_notification()
RETURNS TRIGGER AS $$
BEGIN
  -- Only create notification if status changed to confirmed or rejected
  IF (NEW.status = 'confirmed' OR NEW.status = 'rejected') 
     AND (OLD.status IS DISTINCT FROM NEW.status) THEN
    
    INSERT INTO notifications (
      user_id,
      booking_id,
      restaurant_id,
      restaurant_name,
      type,
      title,
      message
    ) VALUES (
      NEW.user_id,
      NEW.id,
      NEW.restaurant_id,
      NEW.restaurant_name,
      CASE 
        WHEN NEW.status = 'confirmed' THEN 'booking_confirmed'
        ELSE 'booking_rejected'
      END,
      CASE 
        WHEN NEW.status = 'confirmed' THEN 'Booking Confirmed! 🎉'
        ELSE 'Booking Rejected 😔'
      END,
      CASE 
        WHEN NEW.status = 'confirmed' THEN 
          'Your booking at ' || NEW.restaurant_name || ' has been confirmed for ' || 
          TO_CHAR(NEW.booking_date, 'Mon DD, YYYY') || ' at ' || NEW.booking_time || '.'
        ELSE 
          'Your booking at ' || NEW.restaurant_name || ' has been rejected. Please contact the restaurant for more information.'
      END
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 6: Create trigger on bookings table
-- =====================================================
DROP TRIGGER IF EXISTS booking_status_notification ON bookings;
CREATE TRIGGER booking_status_notification
  AFTER UPDATE ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION create_booking_notification();

-- =====================================================
-- Setup Complete! ✅
-- =====================================================
-- Test the setup:
-- 1. Update a booking status to 'confirmed' or 'rejected'
-- 2. Check the notifications table for new entries
-- 3. Verify the app displays the notification badge
-- =====================================================
