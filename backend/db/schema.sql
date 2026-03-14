-- Core user profile
CREATE TABLE users (
  id UUID PRIMARY KEY,
  display_name TEXT NOT NULL,
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  native_language VARCHAR(32) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Social graph
CREATE TABLE user_followers (
  follower_id UUID NOT NULL REFERENCES users(id),
  followed_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (follower_id, followed_id)
);

-- Call sessions for billing/analytics
CREATE TABLE call_sessions (
  id UUID PRIMARY KEY,
  caller_id UUID NOT NULL REFERENCES users(id),
  callee_id UUID NOT NULL REFERENCES users(id),
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  duration_seconds INTEGER GENERATED ALWAYS AS (EXTRACT(EPOCH FROM (ended_at - started_at))) STORED
);

-- Daily rollups for weekly chart and streaks
CREATE TABLE practice_minutes_daily (
  user_id UUID NOT NULL REFERENCES users(id),
  practice_date DATE NOT NULL,
  minutes INTEGER NOT NULL CHECK (minutes >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, practice_date)
);

CREATE INDEX idx_practice_minutes_user_date
  ON practice_minutes_daily (user_id, practice_date DESC);

-- Premium subscriptions
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  tier VARCHAR(16) NOT NULL CHECK (tier IN ('weekly', 'monthly', 'six_month')),
  amount_inr INTEGER NOT NULL,
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ NOT NULL,
  provider_ref TEXT
);

-- Redis design (documented):
-- 1) online:users:<language> = Set(user_id)
-- 2) online:users:<language>:male|female = Set(user_id)
-- 3) session:<user_id> = JSON metadata with TTL heartbeat
