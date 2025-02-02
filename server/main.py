from routes import auth, music
from fastapi import FastAPI
from models.base import Base
from database import engine


# use uvicorn main:app --host 0.0.0.0 --port 8000
# fastapi run main.py

app = FastAPI()
app.include_router(auth.router, prefix="/auth")
app.include_router(music.router, prefix="/music")
Base.metadata.create_all(engine)

