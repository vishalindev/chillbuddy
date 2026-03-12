# Buddy Talk

VoIP-based language practice and social connection app scaffold built with Flutter + FastAPI.

## Project structure
- `app/flutter/buddy_talk`: Flutter client (Dark Teal theme, dashboard, rooms, profile stats, premium).
- `backend/services/match_service`: FastAPI microservice with matching, user stats, and signaling websocket.
- `backend/db/schema.sql`: PostgreSQL schema for users, follows, calls, subscriptions, and daily practice minutes.
- `docs/architecture.md`: call flow, API contracts, clean architecture notes, and infra design.
