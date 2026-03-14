from datetime import date
from typing import Literal

from pydantic import BaseModel, Field


class StartMatchRequest(BaseModel):
    user_id: str
    filter: Literal["anyone", "male", "female"] = "anyone"
    preferred_language: str = Field(min_length=2, max_length=32)


class StartMatchResponse(BaseModel):
    match_id: str
    partner_user_id: str
    signaling_ws_url: str
    ice_servers: list[dict]


class DailyPracticeStat(BaseModel):
    day: date
    minutes: int


class UserStatsResponse(BaseModel):
    user_id: str
    following_count: int
    followers_count: int
    current_streak_days: int
    best_streak_days: int
    weekly_minutes: list[DailyPracticeStat]
