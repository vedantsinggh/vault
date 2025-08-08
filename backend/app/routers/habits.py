from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date
from sqlalchemy import func
from .. import schemas, models
from ..database import get_db

router = APIRouter(prefix="/habits", tags=["habits"])

@router.post("/", response_model=schemas.Habit)
def create_habit(habit: schemas.HabitCreate, db: Session = Depends(get_db)):
    db_habit = models.Habit(**habit.model_dump(), streak=0, completion_days=[])
    db.add(db_habit)
    db.commit()
    db.refresh(db_habit)
    return db_habit

@router.get("/", response_model=list[schemas.Habit])
def read_habits(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return db.query(models.Habit).offset(skip).limit(limit).all()

@router.get("/{habit_id}", response_model=schemas.Habit)
def read_habit(habit_id: int, db: Session = Depends(get_db)):
    habit = db.query(models.Habit).filter(models.Habit.id == habit_id).first()
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    return habit

@router.put("/{habit_id}", response_model=schemas.Habit)
def update_habit(habit_id: int, habit: schemas.HabitUpdate, db: Session = Depends(get_db)):
    db_habit = db.query(models.Habit).filter(models.Habit.id == habit_id).first()
    if not db_habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    update_data = habit.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_habit, key, value)
    
    db.commit()
    db.refresh(db_habit)
    return db_habit

@router.delete("/{habit_id}")
def delete_habit(habit_id: int, db: Session = Depends(get_db)):
    habit = db.query(models.Habit).filter(models.Habit.id == habit_id).first()
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    db.delete(habit)
    db.commit()
    return {"message": "Habit deleted successfully"}

@router.post("/{habit_id}/complete", response_model=schemas.Habit)
def complete_habit(habit_id: int, db: Session = Depends(get_db)):
    habit = db.query(models.Habit).filter(models.Habit.id == habit_id).first()
    if not habit:
        raise HTTPException(status_code=404, detail="Habit not found")
    
    today = date.today().isoformat()
    if today in habit.completion_days:
        habit.completion_days.remove(today)
        habit.streak = max(0, habit.streak - 1)
    else:
        habit.completion_days.append(today)
        habit.streak += 1
    
    db.commit()
    db.refresh(habit)
    return habit

@router.get("/stats/streaks")
def get_streak_stats(db: Session = Depends(get_db)):
    return {
        "current_streak": db.query(func.max(models.Habit.streak)).scalar() or 0,
        "total_habits": db.query(models.Habit).count()
    }
