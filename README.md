# API de Analítica - Purple Nails Studio

API REST en Python (FastAPI) con 5 endpoints de analítica, conectada a MySQL y escrita con SQL nativo (sin ORM).
La explicación de la homologación de entidades está en [HOMOLOGACION.md](HOMOLOGACION.md).

## Estructura

```
api_purple_nails/
├── app/
│   ├── main.py            # aplicación FastAPI y registro de rutas
│   ├── config.py          # configuración de la conexión
│   ├── database.py        # conexión nativa y cursor
│   └── routes/            # un archivo por endpoint
│       ├── reportes.py    # endpoint 1
│       ├── analitica.py   # endpoint 2
│       ├── items.py       # endpoint 3
│       ├── segmentos.py   # endpoint 4
│       └── operaciones.py # endpoint 5
├── dump_proyecto.sql      # DDL + DML (15 registros por tabla)
├── test_endpoints.http    # pruebas de los 5 endpoints
├── HOMOLOGACION.md
├── requirements.txt
└── README.md
```

## Cómo ejecutarla

1. Enciende **MySQL** en XAMPP.
2. En phpMyAdmin, importa `dump_proyecto.sql` (crea la base `purple_nail_studio`).
3. En la carpeta del proyecto:

```bash
python -m venv venv
venv\Scripts\activate          # en Windows
pip install -r requirements.txt
uvicorn app.main:app --reload
```

4. Abre http://localhost:8000/docs para probar los endpoints, o usa `test_endpoints.http`.

La conexión usa por defecto el usuario `root` sin contraseña (XAMPP). Se puede cambiar con las variables de
entorno `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD` y `DB_NAME`.

## Endpoints

| Método | Ruta |
|---|---|
| GET | `/api/reportes/clasificacion-top` |
| GET | `/api/analitica/actores-estrella` |
| GET | `/api/items/desviacion-grupo` |
| GET | `/api/segmentos/analisis-limpio` |
| GET | `/api/operaciones/resumen-dinamico?min_operaciones=N` |
