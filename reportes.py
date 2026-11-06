from fastapi import APIRouter, HTTPException, Query
from mysql.connector import Error

from database import get_connection

router = APIRouter()


# Endpoint 1: GROUP BY [servicio] + subconsulta escalar en HAVING
@router.get("/api/reportes/clasificacion-top")
def clasificacion_top():
    conexion = None
    try:
        conexion = get_connection()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT s.id_servicio,
                   s.nombre_servicio,
                   COUNT(c.id_cita) AS total_citas,
                   SUM(s.precio)    AS recaudo_total,
                   AVG(s.precio)    AS promedio_por_cita
            FROM servicio s
            INNER JOIN cita c ON c.id_servicio = s.id_servicio
            WHERE c.estado <> 'Cancelada'
            GROUP BY s.id_servicio, s.nombre_servicio
            HAVING AVG(s.precio) > (
                SELECT AVG(s2.precio)
                FROM cita c2
                INNER JOIN servicio s2 ON c2.id_servicio = s2.id_servicio
                WHERE c2.estado <> 'Cancelada'
            )
            ORDER BY recaudo_total DESC
        """)
        filas = cursor.fetchall()
    except Error:
        raise HTTPException(status_code=500, detail="Error al consultar la base de datos")
    finally:
        if conexion is not None and conexion.is_connected():
            conexion.close()

    if not filas:
        raise HTTPException(status_code=404, detail="No hay servicios por encima del promedio global")
    return {"total": len(filas), "datos": filas}


# Endpoint 2: GROUP BY [cliente] + subconsulta con tabla derivada en HAVING
@router.get("/api/analitica/actores-estrella")
def actores_estrella():
    conexion = None
    try:
        conexion = get_connection()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT cl.id_cliente,
                   CONCAT(cl.nombre, ' ', cl.apellido) AS cliente,
                   COUNT(c.id_cita)                    AS total_citas,
                   SUM(s.precio)                       AS gasto_total
            FROM cliente cl
            INNER JOIN cita c     ON c.id_cliente = cl.id_cliente
            INNER JOIN servicio s ON c.id_servicio = s.id_servicio
            WHERE c.estado <> 'Cancelada'
            GROUP BY cl.id_cliente, cl.nombre, cl.apellido
            HAVING SUM(s.precio) > (
                SELECT AVG(t.total)
                FROM (
                    SELECT SUM(s2.precio) AS total
                    FROM cita c2
                    INNER JOIN servicio s2 ON c2.id_servicio = s2.id_servicio
                    WHERE c2.estado <> 'Cancelada'
                    GROUP BY c2.id_cliente
                ) AS t
            )
            ORDER BY gasto_total DESC
        """)
        filas = cursor.fetchall()
    except Error:
        raise HTTPException(status_code=500, detail="Error al consultar la base de datos")
    finally:
        if conexion is not None and conexion.is_connected():
            conexion.close()

    if not filas:
        raise HTTPException(status_code=404, detail="No hay clientes por encima del promedio acumulado")
    return {"total": len(filas), "datos": filas}


# Endpoint 3: GROUP BY [empleado] + subconsulta correlacionada en HAVING
@router.get("/api/items/desviacion-grupo")
def desviacion_grupo():
    conexion = None
    try:
        conexion = get_connection()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT e.id_empleado,
                   e.nombre,
                   e.apellido,
                   e.especialidad,
                   COUNT(c.id_cita) AS citas_atendidas
            FROM empleado e
            LEFT JOIN cita c ON c.id_empleado = e.id_empleado
                            AND c.estado <> 'Cancelada'
            GROUP BY e.id_empleado, e.nombre, e.apellido, e.especialidad
            HAVING COUNT(c.id_cita) < (
                SELECT COUNT(c3.id_cita) / COUNT(DISTINCT e3.id_empleado)
                FROM empleado e3
                LEFT JOIN cita c3 ON c3.id_empleado = e3.id_empleado
                                 AND c3.estado <> 'Cancelada'
                WHERE e3.especialidad = e.especialidad
            )
            ORDER BY e.especialidad, e.id_empleado
        """)
        filas = cursor.fetchall()
    except Error:
        raise HTTPException(status_code=500, detail="Error al consultar la base de datos")
    finally:
        if conexion is not None and conexion.is_connected():
            conexion.close()

    if not filas:
        raise HTTPException(status_code=404, detail="No hay empleadas por debajo del promedio de su especialidad")
    return {"total": len(filas), "datos": filas}


# Endpoint 4: GROUP BY [turno] + subconsulta NOT IN en WHERE
@router.get("/api/segmentos/analisis-limpio")
def analisis_limpio():
    conexion = None
    try:
        conexion = get_connection()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT CASE WHEN HOUR(c.hora) < 12 THEN 'Mañana' ELSE 'Tarde' END AS turno,
                   COUNT(c.id_cita) AS total_citas,
                   SUM(s.precio)    AS total_valor
            FROM cita c
            INNER JOIN servicio s ON c.id_servicio = s.id_servicio
            WHERE c.id_cliente NOT IN (
                SELECT c2.id_cliente
                FROM cita c2
                WHERE c2.estado = 'Cancelada'
            )
            GROUP BY turno
            ORDER BY total_valor DESC
        """)
        filas = cursor.fetchall()
    except Error:
        raise HTTPException(status_code=500, detail="Error al consultar la base de datos")
    finally:
        if conexion is not None and conexion.is_connected():
            conexion.close()

    if not filas:
        raise HTTPException(status_code=404, detail="No hay datos tras excluir los casos críticos")
    return {"total": len(filas), "datos": filas}


# Endpoint 5: GROUP BY [estado] + parámetro en HAVING + subconsulta MIN
@router.get("/api/operaciones/resumen-dinamico")
def resumen_dinamico(min_operaciones: int = Query(2, ge=1)):
    conexion = None
    try:
        conexion = get_connection()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT c.estado,
                   COUNT(c.id_cita) AS total_operaciones,
                   SUM(s.precio)    AS total_valor,
                   AVG(s.precio)    AS promedio_por_operacion
            FROM cita c
            INNER JOIN servicio s ON c.id_servicio = s.id_servicio
            GROUP BY c.estado
            HAVING COUNT(c.id_cita) >= %s
               AND AVG(s.precio) > (SELECT MIN(precio) FROM servicio)
            ORDER BY total_operaciones DESC
        """, (min_operaciones,))
        filas = cursor.fetchall()
    except Error:
        raise HTTPException(status_code=500, detail="Error al consultar la base de datos")
    finally:
        if conexion is not None and conexion.is_connected():
            conexion.close()

    if not filas:
        raise HTTPException(status_code=404, detail="Ningún grupo cumple con el mínimo de operaciones indicado")
    return {"min_operaciones": min_operaciones, "total": len(filas), "datos": filas}
