from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import date
from .. import schemas, models
from ..database import get_db

router = APIRouter(prefix="/timeblocks", tags=["timeblocks"])

@router.post("/", response_model=schemas.TimeBlock)
def create_timeblock(timeblock: schemas.TimeBlockCreate, db: Session = Depends(get_db)):
    db_timeblock = models.TimeBlock(**timeblock.model_dump())
    db.add(db_timeblock)
    db.commit()
    db.refresh(db_timeblock)
    return db_timeblock

@router.get("/", response_model=list[schemas.TimeBlock])
def read_timeblocks(date: date, db: Session = Depends(get_db)):
    return db.query(models.TimeBlock).filter(models.TimeBlock.date == date).all()

@router.get("/{timeblock_id}", response_model=schemas.TimeBlock)
def read_timeblock(timeblock_id: int, db: Session = Depends(get_db)):
    timeblock = db.query(models.TimeBlock).filter(models.TimeBlock.id == timeblock_id).first()
    if not timeblock:
        raise HTTPException(status_code=404, detail="TimeBlock not found")
    return timeblock

@router.put("/{timeblock_id}", response_model=schemas.TimeBlock)
def update_timeblock(
    timeblock_id: int, 
    timeblock: schemas.TimeBlockUpdate, 
    db: Session = Depends(get_db)
):
    db_timeblock = db.query(models.TimeBlock).filter(models.TimeBlock.id == timeblock_id).first()
    if not db_timeblock:
        raise HTTPException(status_code=404, detail="TimeBlock not found")
    
    for key, value in timeblock.model_dump(exclude_unset=True).items():
        setattr(db_timeblock, key, value)
    
    db.commit()
    db.refresh(db_timeblock)
    return db_timeblock

@router.delete("/{timeblock_id}")
def delete_timeblock(timeblock_id: int, db: Session = Depends(get_db)):
    timeblock = db.query(models.TimeBlock).filter(models.TimeBlock.id == timeblock_id).first()
    if not timeblock:
        raise HTTPException(status_code=404, detail="TimeBlock not found")
    
    db.delete(timeblock)
    db.commit()
    return {"message": "TimeBlock deleted successfully"}
