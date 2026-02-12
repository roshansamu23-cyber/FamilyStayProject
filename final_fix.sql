-- FINAL FIX FOR HOLY FAMILY STAY (Constraints Handled)
-- Run this ENTIRE SCRIPT in Supabase SQL Editor

-- 1. Enable RLS on core tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_occupancy ENABLE ROW LEVEL SECURITY;

-- 2. Ensure the Admin User exists in the public 'users' table and has invoke rights
-- We provide default values for 'mobile' and 'city' to satisfy NOT NULL constraints
INSERT INTO public.users (id, email, role, full_name, mobile, city)
SELECT 
  id, 
  email, 
  'admin', 
  COALESCE(raw_user_meta_data->>'full_name', 'Holy Family Admin'),
  COALESCE(raw_user_meta_data->>'mobile', '0000000000'), -- Dummy mobile if missing
  COALESCE(raw_user_meta_data->>'city', 'Srinagar')      -- Dummy city if missing
FROM auth.users
WHERE email = 'holyfamilychurchsrinagar@gmail.com'
ON CONFLICT (id) DO UPDATE
SET role = 'admin';

-- 3. Create/Update the Admin Check Function (SECURITY DEFINER to bypass RLS)
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM users
    WHERE id = auth.uid()
    AND (role = 'admin' OR email = 'holyfamilychurchsrinagar@gmail.com')
  );
END;
$$;

-- 4. BOOOKINGS POLICIES (Comprehensive)

-- Allow Admins (via role OR specific email) to see EVERYTHING
DROP POLICY IF EXISTS "Admins can see all bookings" ON bookings;
CREATE POLICY "Admins can see all bookings"
ON bookings FOR SELECT
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com'
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com' -- Explicit Whitelist
);

DROP POLICY IF EXISTS "Users can see own bookings" ON bookings;
CREATE POLICY "Users can see own bookings"
ON bookings FOR SELECT
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can create bookings" ON bookings;
CREATE POLICY "Users can create bookings"
ON bookings FOR INSERT
WITH CHECK (
  auth.uid() = user_id 
  OR is_admin() = true 
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com'
);

DROP POLICY IF EXISTS "Admins can update bookings" ON bookings;
CREATE POLICY "Admins can update bookings"
ON bookings FOR UPDATE
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com'
);

DROP POLICY IF EXISTS "Admins can delete bookings" ON bookings;
CREATE POLICY "Admins can delete bookings"
ON bookings FOR DELETE
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com'
);

-- 5. ROOM OCCUPANCY POLICIES

DROP POLICY IF EXISTS "Admins can see all occupancy" ON room_occupancy;
CREATE POLICY "Admins can see all occupancy"
ON room_occupancy FOR SELECT
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com'
);

DROP POLICY IF EXISTS "Public view occupancy" ON room_occupancy;
CREATE POLICY "Public view occupancy"
ON room_occupancy FOR SELECT
USING (true); 

DROP POLICY IF EXISTS "Admins can manage occupancy" ON room_occupancy;
CREATE POLICY "Admins can manage occupancy"
ON room_occupancy FOR ALL
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com'
);

-- 6. USERS TABLE POLICIES (Access to profiles)

DROP POLICY IF EXISTS "Users can read own profile" ON users;
CREATE POLICY "Users can read own profile" ON users FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Admins can read all profiles" ON users;
CREATE POLICY "Admins can read all profiles" ON users FOR SELECT 
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'holyfamilychurchsrinagar@gmail.com'
);
