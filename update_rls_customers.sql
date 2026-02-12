-- Allow users to see bookings by Email OR User ID
DROP POLICY IF EXISTS "Users can see own bookings" ON bookings;

CREATE POLICY "Users can see own bookings"
ON bookings FOR SELECT
USING (
  auth.uid() = user_id
  OR email = (auth.jwt() ->> 'email')
);
