# FletX API: Gestión de Manifiestos y Logística

Este documento describe los pasos necesarios para configurar, ejecutar y entender la aplicación FletX, una API desarrollada en Ruby on Rails para la gestión de manifiestos y seguimiento de rutas logísticas.

---

## 💻 Requisitos del Sistema

* **Versión de Ruby:** 3.3.0 (Verificado con el archivo `.ruby-version`)
* **Dependencias del Sistema:** `build-essential`, `libpq-dev` (para PostgreSQL).
* **Contenedorización:** **Docker** y **Docker Compose** (Herramientas principales para desarrollo y entorno de base de datos).

---

## ️ Configuración y Ejecución

Utilizamos Docker para asegurar un entorno de desarrollo consistente.

### 1. Configuración del Entorno

Asegúrate de que los archivos de configuración de Docker (`.dockerignore`, `Dockerfile`, `docker-compose.yml`) estén en la raíz y configurados para tu entorno.

### 2. Base de Datos y Dependencias

Ejecuta el entorno de Docker para crear la base de datos y correr las migraciones:

```bash
# 1. Levantar el entorno (Base de Datos y Aplicación)
docker compose up -d

# 2. Instalar las gemas dentro del contenedor de la aplicación
docker compose exec app bundle install

# 3. Crear la base de datos (PostgreSQL)
docker compose exec app bundle exec rails db:create

# 4. Ejecutar las migraciones
docker compose exec app bundle exec rails db:migrate

# 5. Inicialización de la base de datos (Seeding)
docker compose exec app bundle exec rails db:seed
```
## Ejercicio 3

Para obtener  los manifestos en estado in_route junto con su última parada
completada el enfoque que tomaria seria una subconsulta agregada con MAX() combinada con un JOIN.
ya que esta me permite evitar las subconsultas correlaciondas ( para le manifiesto # 1 cual es la ultima
parada x manifiesto) mientras que un max group by le dice a la base de datos, 
dame la hora de finalización más reciente para TODOS los manifiestos

### Indices sugeridos
stops: CREATE INDEX idx_stops_comp_manifesto ON stops (status, manifesto_id, completed_at DESC);
Justificación: Este índice acelera la subconsulta LatestCompleted. Permite a la base de datos filtrar rápidamente por status = 2 y luego agrupar (manifesto_id) y encontrar el máximo (completed_at) de manera muy eficiente, ya que los datos están preordenados en el índice.

manifestos: CREATE INDEX idx_manifestos_status ON manifestos (status, id);
Justificación: Optimiza el filtro final m.status = 1 y la clave de unión.

```sql
SELECT
    m.id AS manifesto_id,
    m.status AS manifesto_status,
    s.id AS last_stop_id,
    s.address AS last_stop_address,
    s.completed_at AS last_completed_at
FROM
    manifestos m
JOIN
    -- 1. Subconsulta agregada para encontrar la hora de completado más reciente por manifiesto
    (
        SELECT
            manifesto_id,
            MAX(completed_at) AS max_completed_at
        FROM
            stops
        WHERE
            status = 2 -- Asumiendo estado 'completed'
        GROUP BY
            manifesto_id
    ) AS LatestCompleted ON m.id = LatestCompleted.manifesto_id
JOIN
    -- 2. Join con la tabla original de stops para obtener los detalles completos (ej. address)
    stops s ON s.manifesto_id = LatestCompleted.manifesto_id 
           AND s.completed_at = LatestCompleted.max_completed_at
WHERE
    m.status = 1; -- Filtro final para manifiestos 'in_route'
```

## Ejercicio 4
Los Background Jobs tares en segundo plano que genralmente usamos para ejecutar tareas largas, lentas o periódicas fuera del flujo principal.
Para  implementar un job en Sidekiq con scheduler que detecte manifiestos sin cambios por más
de 2 horas. Basicamente 
*crear un worker que realizar una consulta a la base de datos para encontrar manifiestos inactivos.
*Configurar el scheduler con una regla CRON o un intervalo para que Sidekiq  encole y ejecute el job.
*El worker procesa los resultados, la acción deseada.
