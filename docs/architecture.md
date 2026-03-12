# Buddy Talk Architecture (Flutter + FastAPI)

## 1) UI/UX theme: Dark Teal
- Primary background: deep blue/teal.
- Surfaces/cards: lighter teal panels.
- CTA buttons: bright mint/green with high contrast against dark surfaces.
- Rounded corners: 18-20px on cards/buttons, giving a friendly social feel.
- Typography: bold value labels for call/streak metrics.

## 2) Flutter clean architecture layout
- `core/`: theme, shared constants.
- `features/*/presentation`: screens and providers.
- `features/*/domain`: use-cases/entities (to expand in production).
- `features/*/data`: repositories + remote data sources.

Current scaffold uses `provider` for state management and can be evolved into feature modules.

## 3) Incoming call logic (background/terminated)
1. Caller requests match via `POST /start-match`.
2. Backend allocates partner and notifies callee via push (FCM/APNs) with `match_id`.
3. Native layer wakes:
   - iOS: CallKit incoming UI.
   - Android: Telecom `ConnectionService` incoming UI.
4. If user accepts from native UI, app boots and restores user auth/session.
5. App opens WebSocket signaling channel `/ws/signaling/{match_id}`.
6. Offer/Answer + ICE candidates exchanged over WebSocket.
7. WebRTC peer connection established for audio stream.
8. App transitions to in-call screen; keepalive heartbeats update Redis online status.
9. On call end, duration persists in PostgreSQL and minutes roll up into daily stats.

## 4) API contracts
### `POST /start-match`
Request body:
```json
{
  "user_id": "uuid",
  "filter": "anyone|male|female",
  "preferred_language": "english"
}
```
Response body:
```json
{
  "match_id": "uuid",
  "partner_user_id": "uuid",
  "signaling_ws_url": "wss://.../ws/signaling/{match_id}",
  "ice_servers": [{"urls": "stun:..."}]
}
```

### `GET /user-stats/{user_id}`
Response body:
```json
{
  "user_id": "uuid",
  "following_count": 128,
  "followers_count": 211,
  "current_streak_days": 6,
  "best_streak_days": 14,
  "weekly_minutes": [
    {"day": "2026-03-08", "minutes": 18}
  ]
}
```

## 5) Data model for practice minutes
Weekly chart is backed by `practice_minutes_daily(user_id, practice_date, minutes)`.
- One row per user per day.
- Upsert at call completion to accumulate total daily minutes.
- Weekly chart query filters Sunday->Saturday window in local timezone.

## 6) Infra notes for AWS/Azure scale
- API services: containerized FastAPI on ECS/Fargate or AKS.
- WebSocket signaling: separate autoscaled deployment with sticky routing by `match_id`.
- PostgreSQL: managed (RDS/Azure Database for PostgreSQL).
- Redis: managed cache for online presence + transient matching queues.
- Object logs/metrics: CloudWatch or Azure Monitor + OpenTelemetry traces.
- TURN/STUN: Coturn cluster with regional endpoints for NAT traversal.
