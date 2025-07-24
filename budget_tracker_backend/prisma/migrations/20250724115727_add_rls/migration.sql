-- ─────────────────────────────────────────────────────────────────────────────
-- GRANT TABLE-LEVEL RIGHTS
-- ─────────────────────────────────────────────────────────────────────────────

GRANT USAGE ON SCHEMA public TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
  ON ALL TABLES IN SCHEMA public
  TO app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

-- ─────────────────────────────────────────────────────────────────────────────
-- USERS TABLE
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY insert_policy_app_user
  ON public.users
  FOR INSERT
  TO app_user
  WITH CHECK (true);

CREATE POLICY select_policy_app_user
  ON public.users
  FOR SELECT
  TO app_user
  USING (true);

-- ─────────────────────────────────────────────────────────────────────────────
-- SESSIONS TABLE
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY insert_policy_app_user
  ON public.sessions
  FOR INSERT
  TO app_user
  WITH CHECK (true);

CREATE POLICY select_policy_app_user
  ON public.sessions
  FOR SELECT
  TO app_user
  USING (true);

CREATE POLICY delete_policy_app_user
  ON public.sessions
  FOR DELETE
  TO app_user
  USING (true);

-- ─────────────────────────────────────────────────────────────────────────────
-- EXPENSES TABLE
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY insert_policy_app_user
  ON public.expenses
  FOR INSERT
  TO app_user
  WITH CHECK (true);

CREATE POLICY select_policy_app_user
  ON public.expenses
  FOR SELECT
  TO app_user
  USING (true);

CREATE POLICY delete_policy_app_user
  ON public.expenses
  FOR DELETE
  TO app_user
  USING (true);
