import os
import uuid
import bcrypt
from dotenv import load_dotenv
from fastapi import Depends, HTTPException, APIRouter
import jwt
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from pydantic_schemas.user_login import UserLogin
from sqlalchemy.orm import Session



load_dotenv()
router = APIRouter()

@router.post("/signup", status_code=201)
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
    # check if the user with same email exists in the database
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(status_code=400, detail="User already exists")
    
    # add the user to the database
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    new_user = User(id= str(uuid.uuid4()), email=user.email, name=user.name, password=hashed_pw)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


secret_key = os.getenv('SECRET_KEY')
if not secret_key:
    raise RuntimeError("SECRET_KEY environment variable is not set!")


@router.post("/login")
def login_user(user: UserLogin, db: Session=Depends(get_db)):
    # check if the user with same email exists in the database
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(status_code=400, detail="User does not exist")
    
    if not bcrypt.checkpw(user.password.encode(), user_db.password):
        raise HTTPException(status_code=400, detail="Invalid password")

    token = jwt.encode({'id': user_db.id}, secret_key, algorithm='HS256')
    
    return {'token' : token, 'user': user_db}


@router.get("/")
def get_user_data(db: Session=Depends(get_db), user_dict = Depends(auth_middleware)):
   # from the postgress database get the user data
   user = db.query(User).filter(User.id == user_dict['uid']).first()
   if not user:
       raise HTTPException(status_code=404, detail="User does not exist")
   return user