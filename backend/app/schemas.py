from datetime import datetime, date
from typing import Optional, List
from pydantic import BaseModel

class BaseSchema(BaseModel):
    class Config:
        from_attributes = True

# Task schemas
class TaskBase(BaseSchema):
    title: str
    description: Optional[str] = None
    date: datetime
    priority: str = "medium"
    is_completed: bool = False

class TaskCreate(TaskBase):
    pass

class TaskUpdate(BaseSchema):
    title: Optional[str] = None
    description: Optional[str] = None
    date: Optional[datetime] = None
    priority: Optional[str] = None
    is_completed: Optional[bool] = None

class Task(TaskBase):
    id: int
    created_at: datetime

# Habit schemas
class HabitBase(BaseSchema):
    title: str
    description: Optional[str] = None
    frequency: str = "daily"
    color: str = "#2196F3"

class HabitCreate(HabitBase):
    pass

class HabitUpdate(BaseSchema):
    title: Optional[str] = None
    description: Optional[str] = None
    frequency: Optional[str] = None
    color: Optional[str] = None

class Habit(HabitBase):
    id: int
    streak: int
    completion_days: List[str]
    created_at: datetime

# Expense schemas
class ExpenseBase(BaseSchema):
    title: str
    amount: float
    category: str
    date: date
    description: Optional[str] = None
    payment_method: str

class ExpenseCreate(ExpenseBase):
    pass

class ExpenseUpdate(BaseSchema):
    title: Optional[str] = None
    amount: Optional[float] = None
    category: Optional[str] = None
    date: Optional[date] = None
    description: Optional[str] = None
    payment_method: Optional[str] = None

class Expense(ExpenseBase):
    id: int
    created_at: datetime

class ExpenseCategoryBase(BaseSchema):
    name: str
    icon: str
    color: str

class ExpenseCategoryCreate(ExpenseCategoryBase):
    pass

class ExpenseCategory(ExpenseCategoryBase):
    id: int

# TimeBlock schemas
class TimeBlockBase(BaseSchema):
    title: str
    description: Optional[str] = None
    start_time: datetime
    end_time: datetime
    color: str = "#2196F3"
    date: date

class TimeBlockCreate(TimeBlockBase):
    pass

class TimeBlock(TimeBlockBase):
    id: int
    created_at: datetime

class TimeBlockUpdate(BaseSchema):
    title: Optional[str] = None
    description: Optional[str] = None
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    color: Optional[str] = None
    date: Optional[date] = None
