from sqlalchemy import Column, Integer, String, Boolean
from .database import Base  # Import Base from database.py

class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String, index=True)
    is_completed = Column(Boolean, default=False)
