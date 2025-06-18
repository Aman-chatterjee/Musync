from sqlalchemy import TEXT, Column, ForeignKey
from sqlalchemy.orm import relationship
from models.base import Base

class Favorite(Base):
    __tablename__ = 'favorites'
    id = Column(TEXT, primary_key = True)
    music_id = Column(TEXT, ForeignKey('music.id'))
    user_id = Column(TEXT, ForeignKey('users.id'))

    music = relationship('Music')
    user = relationship("User", back_populates='favorites')