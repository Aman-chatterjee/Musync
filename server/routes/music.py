import os
import uuid
import cloudinary
import cloudinary.uploader
from dotenv import load_dotenv
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from sqlalchemy import asc, desc
from database import get_db
from sqlalchemy.orm import Session, joinedload

from middleware.auth_middleware import auth_middleware
from models.favorite import Favorite
from models.music import Music
from pydantic_schemas.favorite_music import FavoriteMusic

load_dotenv()
router = APIRouter()


api_key = os.getenv('CLOUDINARY_API_KEY')
api_secret =  os.getenv('CLOUDINARY_SECRET_KEY')

if not api_key:
    raise RuntimeError("API_KEY environment variable is not set!")

if not api_secret:
    raise RuntimeError("API_SECRET environment variable is not set!")



# Configuration       
cloudinary.config( 
    cloud_name = "djj2ume3q", 
    api_key = api_key, 
    api_secret = api_secret, # Click 'View API Keys' above to copy your API secret
    secure=True
)

@router.post("/upload", status_code=201)
def upload_music(music: UploadFile = File(...),
                  thumbnail: UploadFile = File(...),
                    music_name: str = Form(...),
                      artist_name: str = Form(),
                        hex_code: str = Form(...),
                         db: Session = Depends(get_db),
                         auth_dict = Depends(auth_middleware)): #This statement is not being used but is very important, (Don't remove)
    
    # Upload the music
    music_id = str(uuid.uuid4())
    music_res  = cloudinary.uploader.upload(music.file, resource_type = 'auto', folder = f'music/{music_id}')
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type = 'image', folder = f'music/{music_id}')

    new_music = Music(
        id = music_id,
        music_name = music_name,
        artist_name = artist_name,
        hex_code = hex_code,
        music_url = music_res['url'],
        thumbnail_url = thumbnail_res['url']
    )

    db.add(new_music)
    db.commit()
    db.refresh(new_music)
    return new_music


@router.get('/list', status_code = 200)
def list_music(db: Session = Depends(get_db), auth_dict = Depends(auth_middleware)):
    musics = db.query(Music).order_by(desc(Music.created_at)).all()
    if not musics:
        raise HTTPException(status_code=404, detail="Couldn't get music list")

    return musics


@router.post('/favorite')
def favorite_music(fav_music: FavoriteMusic, db: Session = Depends(get_db), auth_details = Depends(auth_middleware)):
    # Music already favorited by the user
    user_id = auth_details['uid']
    fav = db.query(Favorite).filter(Favorite.music_id == fav_music.music_id, Favorite.user_id == user_id).first()

    if fav:
        db.delete(fav)
        db.commit()
        #db.refresh(fav)
        return {'message' : False}
    else:
        id = uuid.uuid4()
        new_fav = Favorite(id = str(id), music_id = fav_music.music_id, user_id = user_id)
        db.add(new_fav)
        db.commit()
        db.refresh(new_fav)

    return {'message' : True}
    

@router.get('/list/favorites', status_code = 200)
def list_fav_music(db: Session = Depends(get_db), auth_detials = Depends(auth_middleware)):
    user_id = auth_detials['uid']
    fav_music = db.query(Favorite).filter(Favorite.user_id == user_id).options(joinedload(Favorite.music)).all()
    if not fav_music:
        raise HTTPException(status_code=204, detail="It's looking so empty")

    return fav_music