from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import tasks, habits, expenses, timeblocks
from . import models, database

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (for development)
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

models.Base.metadata.create_all(bind=database.engine)

app.include_router(tasks.router)
app.include_router(habits.router)
app.include_router(expenses.router)
app.include_router(timeblocks.router)

@app.get("/")
def read_root():
    return {"msg": "VAULT API is running!"}
