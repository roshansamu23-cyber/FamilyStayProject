-- RLS FIX FOR HOLY FAMILY STAY (Comprehensive)

-- 1. Create a secure function to check admin status
-- This function runs with SECURITY DEFINER privileges to bypass RLS checks
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
    AND role = 'admin'
  );
END;
$$;

-- 2. "users" table policies 
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own profile" ON users;
CREATE POLICY "Users can read own profile" ON users FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Admins can read all profiles" ON users;
CREATE POLICY "Admins can read all profiles" ON users FOR SELECT 
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com' 
);


-- 3. "bookings" table policies
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can see all bookings" ON bookings;
CREATE POLICY "Admins can see all bookings"
ON bookings FOR SELECT
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com'
);

DROP POLICY IF EXISTS "Users can see own bookings" ON bookings;
CREATE POLICY "Users can see own bookings"
ON bookings FOR SELECT
USING (
  auth.uid() = user_id
);

DROP POLICY IF EXISTS "Users can create bookings" ON bookings;
CREATE POLICY "Users can create bookings"
ON bookings FOR INSERT
WITH CHECK (
  auth.uid() = user_id 
  OR is_admin() = true 
);

DROP POLICY IF EXISTS "Admins can update bookings" ON bookings;
CREATE POLICY "Admins can update bookings"
ON bookings FOR UPDATE
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com'
);

DROP POLICY IF EXISTS "Admins can delete bookings" ON bookings;
CREATE POLICY "Admins can delete bookings"
ON bookings FOR DELETE
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com'
);

-- 4. "room_occupancy" table policies (CRITICAL FOR DASHBOARD VISIBILITY)
ALTER TABLE room_occupancy ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can see all occupancy" ON room_occupancy;
CREATE POLICY "Admins can see all occupancy"
ON room_occupancy FOR SELECT
USING (
  is_admin() = true
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com'
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
  OR (auth.jwt() ->> 'email') = 'admin@holyfamilystay.com'
);
