# Documento de Homologación - Purple Nails Studio

> En mi proyecto de **Centro de Uñas (Purple Nails Studio)**, la Entidad Catálogo es **`servicio`**,
> la Entidad Ítem/Recurso es **`empleado`** (clasificado por su `especialidad`), la Entidad
> Transaccional es **`cita`**, la Entidad Actor es **`cliente`** y la Entidad de Contexto es el
> **turno de la cita** (Mañana o Tarde, calculado con la hora).

## Matriz de homologación

| Rol arquetípico | Tabla / atributo de mi proyecto | Justificación |
|---|---|---|
| A. Entidad Catálogo / Clasificadora | `servicio` | Catálogo de lo que ofrece el centro (manicure, pedicure, uñas acrílicas...). Cada cita se clasifica por el servicio que incluye. |
| B. Entidad Ítem / Recurso | `empleado` (agrupado por `especialidad`) | Recurso individual que ejecuta la operación. Las empleadas se comparan con las de su misma especialidad. |
| C. Entidad Transaccional | `cita` | Evento operativo con fecha, hora y estado. Su valor sale del precio del servicio asociado (`cita.id_servicio`). |
| D. Entidad Actor / Sujeto | `cliente` | Persona que demanda el servicio. |
| E. Entidad de Contexto / Segmentación | Turno (derivado de `cita.hora`) | Divide la operación en Mañana (antes de las 12:00) y Tarde. |

Tablas del modelo: `cliente`, `empleado`, `servicio`, `cita`, `horario` y `usuario`.

## Qué responde cada endpoint en mi negocio

### 1. `GET /api/reportes/clasificacion-top`
**Pregunta de negocio:** ¿qué servicios generan un valor por cita superior al promedio de todo el centro?
Agrupa las citas no canceladas por servicio y muestra cuántas citas tuvo, el recaudo total y el valor promedio por cita.
Solo deja los servicios cuyo promedio es mayor al promedio general (subconsulta escalar en `HAVING`).
Sirve para decidir qué servicios premium promocionar.

### 2. `GET /api/analitica/actores-estrella`
**Pregunta de negocio:** ¿quiénes son las clientas que más gastan?
Agrupa por cliente y suma lo que ha gastado en citas no canceladas. Solo deja a las clientas cuyo gasto total supera el gasto promedio de todas las clientas.
Ese promedio se calcula con una subconsulta sobre una tabla derivada (`FROM (SELECT ... GROUP BY id_cliente) AS t`) dentro del `HAVING`.
Sirve para identificar a las clientas fieles y ofrecerles beneficios.

### 3. `GET /api/items/desviacion-grupo`
**Pregunta de negocio:** ¿qué empleadas tienen menos citas que sus compañeras de la misma especialidad?
Agrupa por empleada y cuenta sus citas no canceladas. Compara cada una con el promedio de citas de las empleadas de su misma especialidad mediante una subconsulta correlacionada en `HAVING` (usa `e.especialidad` de la consulta externa).
Sirve para repartir mejor la agenda entre las empleadas.

### 4. `GET /api/segmentos/analisis-limpio`
**Pregunta de negocio:** ¿cómo se reparte la operación entre la mañana y la tarde, sin contar a las clientas con cancelaciones?
Agrupa las citas por turno y calcula el total de citas y el valor total.
Excluye con `NOT IN` en el `WHERE` a las clientas que tienen al menos una cita cancelada (caso crítico).
Sirve para ver en qué turno se concentra el negocio real.

### 5. `GET /api/operaciones/resumen-dinamico?min_operaciones=N`
**Pregunta de negocio:** ¿qué estados de cita tienen un volumen relevante y un valor medio por encima del servicio más barato?
Recibe `min_operaciones` (por defecto 2), agrupa las citas por estado y deja solo los grupos con al menos N citas y cuyo promedio por cita supera el precio del servicio más económico (`MIN(precio)` del catálogo).
El parámetro se inyecta con `%s` y una tupla, nunca concatenado.
Sirve para auditar cuántas citas hay en cada estado (Completada, Pendiente, Confirmada, Cancelada).

## Códigos HTTP

| Código | Cuándo |
|---|---|
| 200 | La consulta devolvió registros |
| 404 | La consulta no devolvió registros |
| 500 | Error al consultar la base de datos |
| 422 | Parámetro inválido (por ejemplo `min_operaciones=0`) |
