from fastapi import FastAPI

from reportes import router

app = FastAPI(title="API de Analítica - Purple Nails Studio")
app.include_router(router)


@app.get("/")
def inicio():
    return {"mensaje": "API de Purple Nails Studio en línea", "documentacion": "/docs"}
