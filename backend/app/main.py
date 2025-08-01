from fastapi import FastAPI
from app.routers import tasks, expenses, habits
from app import models, database

app = FastAPI()

models.Base.metadata.create_all(bind=database.engine)

app.include_router(tasks.router)

@app.get("/")
def read_root():
    return {"msg": "VAULT API is running!"}
