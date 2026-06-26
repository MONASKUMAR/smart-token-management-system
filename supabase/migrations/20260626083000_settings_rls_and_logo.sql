-- Drop existing narrow anon policies
DROP POLICY IF EXISTS "Allow anon read access on settings" ON settings;
DROP POLICY IF EXISTS "Allow anon update access on settings" ON settings;
DROP POLICY IF EXISTS "Allow anon read access on tokens" ON tokens;
DROP POLICY IF EXISTS "Allow anon insert access on tokens" ON tokens;
DROP POLICY IF EXISTS "Allow anon update access on tokens" ON tokens;
DROP POLICY IF EXISTS "Allow anon delete access on tokens" ON tokens;

-- Drop public policies if already run to avoid duplication errors
DROP POLICY IF EXISTS "Allow read access on settings" ON settings;
DROP POLICY IF EXISTS "Allow update access on settings" ON settings;
DROP POLICY IF EXISTS "Allow insert access on settings" ON settings;
DROP POLICY IF EXISTS "Allow delete access on settings" ON settings;

DROP POLICY IF EXISTS "Allow read access on tokens" ON tokens;
DROP POLICY IF EXISTS "Allow insert access on tokens" ON tokens;
DROP POLICY IF EXISTS "Allow update access on tokens" ON tokens;
DROP POLICY IF EXISTS "Allow delete access on tokens" ON tokens;

-- Create broad policies targeting both anon and authenticated roles (public)
CREATE POLICY "Allow read access on settings" ON settings FOR SELECT TO public USING (true);
CREATE POLICY "Allow update access on settings" ON settings FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "Allow insert access on settings" ON settings FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Allow delete access on settings" ON settings FOR DELETE TO public USING (true);

CREATE POLICY "Allow read access on tokens" ON tokens FOR SELECT TO public USING (true);
CREATE POLICY "Allow insert access on tokens" ON tokens FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Allow update access on tokens" ON tokens FOR UPDATE TO public USING (true) WITH CHECK (true);
CREATE POLICY "Allow delete access on tokens" ON tokens FOR DELETE TO public USING (true);
