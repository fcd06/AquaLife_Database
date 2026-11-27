# Base de Datos AquaLife - Docker Compose

Configuración de Docker para los servicios del proyecto AquaLife:

- **MySQL** (relacional) – datos principales
- **MongoDB** (documental) – fichas de especie jerárquicas
- **Neo4j** (grafos) – hilos de conversación

---

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `docker-compose.yml` | Orquesta MySQL, MongoDB 7, Neo4j 5 |
| `Dockerfile` | Imagen MySQL con `init.sql` precargado (seed 33) |
| `generate_init_sql.py` | Genera `init.sql` reproducible (~7M filas) |
| `scripts/migrate_neo4j.py` | Migra `Usuario`, `Publicacion`, `Comentar` a Neo4j |
| `scripts/ficha_de_especie_mongodb.py` | Genera 4000 fichas en MongoDB (PascalCase) |
| `scripts/seed_hilos_prueba.py` | Hilos de prueba para benchmarking |
| `000-hash-init.sh` / `zzz-cleanup.sh` | Verificación de hash y limpieza |
| `guidelines.tex` | Orientación del proyecto |

---

## Uso con Docker Compose

### Solo MySQL
```bash
docker compose up -d mysqllab
```

### Las 3 BDs (recomendado)
```bash
docker compose up -d mysqllab mongo neo4j
```

> Primera vez: `docker compose build --progress=plain` y `docker compose up -d`

---

## Verificar MySQL

```bash
docker run --rm --entrypoint sh aqualife-mysql:local -c \
  "sha256sum /docker-entrypoint-initdb.d/init.sql"
```

Hash esperado (seed 33, 2026-01-01):
```
604efe050a6e6197c7dab8060f274792d92086ce21937acd810524e7577908e1
```

---

## Índices adicionales (11)

Creados tras la carga masiva para optimizar consultas y SP.

| Índice | Consultas / SP | Justificación |
|--------|----------------|---------------|
| `Comentar(IDPub, IDPadre)` | `sp_obtener_hilo_comentarios` | CTE recursivo: caso base + JOIN recursivo |
| `Compra(IDUV, IDProd, Fecha)` | 3.e, 3.i | Agrupación vendedor + producto + fecha |
| `Compra(IDUC, Fecha)` | SP: `total_compras` | Filtro comprador + rango fechas |
| `Publicacion(IDU, FechaCreacion)` | SP: `total_publicaciones` | Filtro autor + rango fechas |
| `Reaccionar(IDU, Fecha)` | SP: `total_reacciones_dadas` | Filtro usuario + rango fechas |
| `Comentar(IDU, FechaCreacion)` | SP: `total_comentarios` | Filtro usuario + rango fechas |
| `Contribucion(IDU, Fecha)` | SP: `total_contribuciones` | Filtro usuario + rango fechas |
| `Reaccionar(IDPub)` | 3.a, 3.b, 3.h | JOIN con `Publicacion` (FK no indexa en MySQL 8) |
| `Contribucion(IDProd)` | 3.d, 3.h | JOIN con `Especie` |
| `Especie(IDTA)` | 3.d | JOIN con `TipoAgua` |
| `Compra(IDUV, Puntuacion)` | 3.i, 3.e | Agrupación y filtro puntuaciones 1–5 |

Se crean tras la carga para no penalizar inserción. `docker-compose.yml` usa configuración duradera.

### Verificar
```bash
docker exec aqualife_mysql mysql -uaqualife_user -paqualife_pass -D AquaLife -e "SHOW INDEX FROM Comentar; SHOW INDEX FROM Compra; SHOW INDEX FROM Publicacion; SHOW INDEX FROM Reaccionar; SHOW INDEX FROM Contribucion; SHOW INDEX FROM Especie;"
```

---

## Contenedores

```bash
docker compose ps
# aqualife_mysql (healthy), aqualife_mongo, aqualife_neo4j en estado Up
```

### Logs
```bash
docker compose logs -f mysqllab
docker compose logs -f mongo
docker compose logs -f neo4j
```

### Recursos
```bash
docker stats --no-stream aqualife_mysql aqualife_mongo aqualife_neo4j
```

---

## Credenciales

| Servicio | Host → Puerto | Usuario / Contraseña | BD |
|----------|---------------|----------------------|-----|
| `mysqllab` | `localhost:3306` | `root/root` o `aqualife_user/aqualife_pass` | `AquaLife` |
| `mongo` | `localhost:27017` | `admin/password` (authDB: `admin`) | `AquaLifeDoc` |
| `neo4j` | `localhost:7474` / `7687` | `neo4j/password` | `neo4j` |

---

## Migración MySQL → Neo4j

```bash
# Completa (1.1M comentarios ~6 min)
python3 scripts/migrate_neo4j.py

# Solo usuarios y publicaciones
python3 scripts/migrate_neo4j.py --skip-comments

# Verificar conteos
python3 scripts/migrate_neo4j.py --verify-only

# Dry-run
python3 scripts/migrate_neo4j.py --dry-run
```

---

## Carga MongoDB (fichas especie)

```bash
python3 scripts/ficha_de_especie_mongodb.py
```

Verificación:
```bash
docker exec -it aqualife_mongo mongosh --username admin --password password --authenticationDatabase admin \
  --eval "db.getSiblingDB('AquaLifeDoc').fichas_especie.countDocuments({})"
# 4000
```

---

## Hilos de prueba (benchmarking)

```bash
# 50 publicaciones, 6 niveles (cadena), IDs 2001–2050
python3 scripts/seed_hilos_prueba.py

# 1 publicación, árbol 4×7 niveles → 21,845 comentarios
python3 scripts/seed_hilos_prueba.py --start-pub 6001 --count 1 --branching 4 --depth 7

# 5 publicaciones, árbol ancho
python3 scripts/seed_hilos_prueba.py --start-pub 6001 --count 5 --branching 4 --depth 7
```

Luego en Streamlit → **Gestor de chats** → selecciona 2001, 3001, 6001 para comparar SQL vs Neo4j.

---

## Verificar servicios

### MySQL
```bash
docker exec aqualife_mysql mysql -uaqualife_user -paqualife_pass -D AquaLife -e "SELECT COUNT(*) FROM Comentar;"
```

### MongoDB
```bash
docker exec -it aqualife_mongo mongosh --username admin --password password --authenticationDatabase admin --eval "db.runCommand({ ping: 1 })"
```

### Neo4j
```bash
docker exec -it aqualife_neo4j cypher-shell -u neo4j -p password "RETURN 1 AS ok;"
```

### Migración Neo4j
```bash
docker exec -it aqualife_neo4j cypher-shell -u neo4j -p password "
MATCH (u:Usuario) RETURN count(u) AS usuarios;
MATCH (p:Publicacion) RETURN count(p) AS publicaciones;
MATCH (c:Comentar) RETURN count(c) AS comentarios;
"
```

---

## Jupyter Notebook (MySQL)

```python
%load_ext sql
%sql mysql://root:root@localhost:3306/AquaLife
```

O desde Docker:
```python
%sql mysql://root:root@mysqllab:3306/AquaLife
```

---

## Reiniciar desde cero

```bash
docker compose down -v
docker compose up -d mysqllab mongo neo4j
python3 scripts/migrate_neo4j.py
python3 scripts/ficha_de_especie_mongodb.py
python3 scripts/seed_hilos_prueba.py
```

---

## Diagnóstico

```bash
# Salud MySQL
docker inspect aqualife_mysql | grep -A 5 Health

# Puertos
docker port aqualife_mysql
docker port aqualife_mongo
docker port aqualife_neo4j

# Variables MySQL
docker exec aqualife_mysql mysql -uroot -proot -e "SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit'; SHOW VARIABLES LIKE 'sync_binlog';"

# Índices Comentar
docker exec aqualife_mysql mysql -uaqualife_user -paqualife_pass -D AquaLife -e "SHOW INDEX FROM Comentar;"

# Constraints Neo4j
docker exec -it aqualife_neo4j cypher-shell -u neo4j -p password "SHOW CONSTRAINTS;"

# IDs MongoDB ↔ MySQL
docker exec -it aqualife_mongo mongosh --username admin --password password --authenticationDatabase admin \
  --eval "db.getSiblingDB('AquaLifeDoc').fichas_especie.findOne({}, {IDProd:1, NombreComun:1})"
```