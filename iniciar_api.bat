@echo off
cd /d "%~dp0"
echo ==== API de Purple Nails Studio ====
echo.
if not exist venv (
    echo Creando entorno virtual...
    python -m venv venv
)
call venv\Scripts\activate
echo Instalando lo necesario...
pip install fastapi uvicorn mysql-connector-python
echo.
echo Encendiendo la API. Se abrira el navegador en unos segundos.
echo Para apagarla, cierra esta ventana o pulsa Ctrl + C.
start "" cmd /c "timeout /t 6 /nobreak >nul && start http://localhost:8000/docs"
uvicorn app.main:app --reload
pause
