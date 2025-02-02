import os
from fastapi import HTTPException, Header
import jwt

secret_key = os.getenv('SECRET_KEY')
if not secret_key:
    raise RuntimeError("SECRET_KEY environment variable is not set!")


def auth_middleware(x_auth_token: str = Header(None)):
    try:
        # get the user token from the header
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="No auth token, access denied")

        # decode the token
        verified_token = jwt.decode(x_auth_token, secret_key, algorithms=['HS256'])

        if not verified_token:
            raise HTTPException(status_code=401, detail="Token verification failed, access denied")
    
        # get the user id from the token
        uid = verified_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Token is not valid, Authorization failed")
    
  