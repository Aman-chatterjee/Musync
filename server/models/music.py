from sqlalchemy import TEXT, TIMESTAMP, VARCHAR, Column, func
from sqlalchemy.orm import relationship
from models.base import Base

class Music(Base):
    __tablename__ = 'music'

    id = Column(TEXT, primary_key = True)
    music_url = Column(TEXT)
    thumbnail_url = Column(TEXT)
    artist_name = Column(TEXT)
    music_name = Column(VARCHAR(100))
    hex_code = Column(VARCHAR(6)) 
    created_at = Column(TIMESTAMP, server_default=func.now())  
