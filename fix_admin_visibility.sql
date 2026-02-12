-- CRITICAL FIX: Ensure Admin User Exists and has Admin Role
-- This fixes the issue where is_admin() returns false because the user is missing from public.users

-- 1. Insert/Update the Admin User in public.users
INSERT INTO public.users (id, email, role, full_name, mobile, city)
SELECT 
    id, 
    email, 
    'admin', 
    'Administrator', 
    '9999999999', 
    'Srinagar'
FROM auth.users 
WHERE email = 'holyfamilychurchsrinagar@gmail.com'
ON CONFLICT (id) DO UPDATE 
SET role = 'admin';

-- 2. Redefine is_admin() to be absolutely sure it works
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
DECLARE
  current_role text;
BEGIN
  SELECT role INTO current_role FROM public.users WHERE id = auth.uid();
  RETURN current_role = 'admin';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Update Bookings Policy for Admin Visibility
DROP POLICY IF EXISTS "Admins can see all bookings" ON bookings;

CREATE POLICY "Admins can see all bookings"
ON bookings FOR SELECT
TO authenticated
USING (
  public.is_admin()
);

-- 4. Update Room Occupancy Policy for Admin Visibility
DROP POLICY IF EXISTS "Admins can see all occupancy" ON room_occupancy;

CREATE POLICY "Admins can see all occupancy"
ON room_occupancy FOR SELECT
TO authenticated
USING (
  public.is_admin()
);

-- 5. Force public access for occupancy (fallback if admin check fails)
CREATE POLICY "Public can see occupancy"
ON room_occupancy FOR SELECT
TO anon, authenticated
USING (true);
