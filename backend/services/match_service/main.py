from datetime import date, timedelta
from uuid import uuid4

from fastapi import FastAPI, WebSocket

from schemas import StartMatchRequest, StartMatchResponse, UserStatsResponse, DailyPracticeStat

app = FastAPI(title="Buddy Talk Match Service")


@app.post("/start-match", response_model=StartMatchResponse)
async def start_match(payload: StartMatchRequest) -> StartMatchResponse:
    """
    Match flow:
    1) Resolve online pool from Redis set keyed by language + filter.
    2) Reserve partner with short-lived lock.
    3) Return match + signaling URL for WebRTC negotiation.
    """
    return StartMatchResponse(
        match_id=str(uuid4()),
        partner_user_id="user_8421",
        signaling_ws_url="wss://api.buddytalk.app/ws/signaling/user_8421",
        ice_servers=[{"urls": "stun:stun.l.google.com:19302"}],
    )


@app.get("/user-stats/{user_id}", response_model=UserStatsResponse)
async def user_stats(user_id: str) -> UserStatsResponse:
    today = date.today()
    weekly = [
        DailyPracticeStat(day=today - timedelta(days=6 - i), minutes=minutes)
        for i, minutes in enumerate([18, 22, 14, 31, 27, 42, 35])
    ]
    return UserStatsResponse(
        user_id=user_id,
        following_count=128,
        followers_count=211,
        current_streak_days=6,
        best_streak_days=14,
        weekly_minutes=weekly,
    )


@app.websocket("/ws/signaling/{match_id}")
async def signaling(websocket: WebSocket, match_id: str) -> None:
    await websocket.accept()
    while True:
        message = await websocket.receive_text()
        await websocket.send_text(f"relay:{match_id}:{message}")
