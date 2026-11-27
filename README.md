# AquaLife Database - Proyecto Final Bases de Datos

[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![MongoDB](https://img.shields.io/badge/MongoDB-7.0-47A248?logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Neo4j](https://img.shields.io/badge/Neo4j-5.0-008CC1?logo=neo4j&logoColor=white)](https://neo4j.com/)
[![Docker](https://img.shields.io/badge/Docker-24.0-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Streamlit](https://img.shields.io/badge/Streamlit-1.65-FF4B4B?logo=streamlit&logoColor=white)](https://streamlit.io/)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Índice

- [Descripción del proyecto](#-descripción-del-proyecto)
- [Instalación y ejecución](#-instalación-y-ejecución)
- [Scripts de datos y migración](#-scripts-de-datos-y-migración)
- [Consultas SQL disponibles](#-consultas-sql-disponibles)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Autores](#-autores)
- [Licencia](#-licencia)

---

## Descripción del proyecto

**AquaLife** es el proyecto final de la asignatura de Bases de Datos. Implementa un sistema de información para una comunidad acuática que combina múltiples paradigmas de bases de datos:

- **Relacional (MySQL)**: Modelo principal con usuarios, publicaciones, reacciones, compras, contribuciones, especies y productos.
- **Documental (MongoDB)**: Almacenamiento jerárquico de fichas de especie con documentos secundarios variables (mismos nombres de atributo que en SQL).
- **Grafos (Neo4j)**: Modelo de conversaciones en hilos (comentarios y respuestas anidadas) con comparación de rendimiento frente a la implementación relacional.

La aplicación **Streamlit** (`app/`) proporciona un dashboard interactivo para ejecutar consultas, analizar usuarios, gestionar hilos de comentarios, explorar documentos y auditar precios.

---

## Instalación y ejecución

### 1. Configuración de las bases de datos

Toda la configuración detallada está en **[config_database/README.md](config_database/README.md)**.

### 2. Aplicación Streamlit

```bash
pip install -r requirements.txt
streamlit run app/main.py
```

En la barra lateral introduce tu nombre de usuario para los módulos de chat y auditoría de precios.

---

## Scripts de datos y migración

| Script | Propósito |
|--------|-----------|
| `scripts/migrate_neo4j.py` | Migra `Usuario`, `Publicacion`, `Comentar` de MySQL a Neo4j (idempotente, ~6 min). Opciones: `--skip-comments`, `--verify-only`, `--dry-run`. |
| `scripts/ficha_de_especie_mongodb.py` | Genera 4000 fichas en MongoDB leyendo `Especie` + `Producto` de MySQL (PascalCase). |
| `scripts/seed_hilos_prueba.py` | Crea 50 publicaciones (2001–2050) con hilos de 6 niveles o árboles en MySQL y Neo4j. Idempotente. Opciones: `--count`, `--depth`, `--branching`, `--start-pub`. |

---

## Consultas SQL disponibles

| Archivo | Tarea | Descripción |
|---------|-------|-------------|
| `3_a.sql` | 3.a | Termómetro: reacciones totales por publicación |
| `3_b.sql` | 3.b | Publicaciones mejor recibidas |
| `3_c.sql` | 3.c | Perfil demográfico: distribución de edades |
| `3_d.sql` | 3.d | Tendencias por tipo de agua |
| `3_e.sql` | 3.e | Top 5 vendedores mejor calificados |
| `3_f.sql` | 3.f | Trigger `tgr_auditar_precio` + tabla `Historial_Precios` |
| `3_g.sql` | 3.g | SP `sp_analisis_usuario` |
| `3_h.sql` | 3.h | Top influencers, especies, lift, conversión |
| `3_i.sql` | 3.i | Detección de patrones anómalos (Índice de Sospecha) |
| `comentarios.sql` | -- | Esquema `Comentar` + SP recursivo `sp_obtener_hilo_comentarios` (CTE, `UNION ALL`) |

Todas reproducibles con seed **33** / fecha referencia **2026-01-01**.

---

## Estructura del repositorio

```text
AquaLife_Database/
├── app/                          # Aplicación Streamlit
│   ├── main.py
│   ├── config.py
│   ├── db.py
│   ├── neo4j_db.py
│   └── views/
├── config_database/              # Generación y carga de MySQL
│   ├── generate_init_sql.py
│   ├── Dockerfile
│   ├── 000-hash-init.sh
│   ├── zzz-cleanup.sh
│   └── README.md
├── sql/                          # Consultas y objetos
├── scripts/                      # Scripts auxiliares
├── DOCS/                         # Documentación
├── docker-compose.yml
├── requirements.txt
├── LICENSE
└── README.md
```

---

## Autores

| Nombre (GitHub) | Rol |
|-----------------|-----|
| [**amnesiac-ds**](https://github.com/amnesiac-ds) | SQL completo (Ejercicio 3) |
| [**fcd06**](https://github.com/fcd06) | Neo4j completo (Ejercicio 4) |
| [**darioqr**](https://github.com/darioqr) | MongoDB completo (Ejercicio 5) |

---

## Licencia

**Licencia MIT** — ver [LICENSE](LICENSE).

---

Proyecto académico — Bases de Datos, Curso 2026.