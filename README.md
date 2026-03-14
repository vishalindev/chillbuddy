# Buddy Talk

VoIP-based language practice and social connection app scaffold built with Flutter + FastAPI.

## Project structure
- `app/flutter/buddy_talk`: Flutter client (login + Google OAuth2, dashboard, pod rooms, manual room-id podcast join, profile with location/state lookup).
- `backend/services/match_service`: FastAPI microservice with matching, user stats, and signaling websocket.
- `backend/db/schema.sql`: PostgreSQL schema for users, follows, calls, subscriptions, and daily practice minutes.
- `docs/architecture.md`: call flow, API contracts, clean architecture notes, and infra design.

## Podcast auth integration
- Token API: `https://apivani.sharkdigital.ai/get_token_autenticated`
- LiveKit URL: `wss://rtc.sharkdigital.ai`
