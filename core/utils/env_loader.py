from dotenv import load_dotenv
import os

load_dotenv()

BASE_URL = os.getenv("BASE_URL")
LOGIN_URL = os.getenv("LOGIN_URL")
REGISTRATION_URL = os.getenv("REGISTRATION_URL")
VALID_EMAIL = os.getenv("VALID_EMAIL")
VALID_PASSWORD = os.getenv("VALID_PASSWORD")
SECURITY_QUESTION = os.getenv("SECURITY_QUESTION")