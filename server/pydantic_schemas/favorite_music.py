from pydantic import BaseModel


class FavoriteMusic(BaseModel):
    music_id: str
