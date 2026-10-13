# TODO List - Proyecto Final AquaLife (Bases de Datos)

> **Entrega y Defensa:** Semana 11
> **Restricción Clave:**  No usar ORMs (SQLAlchemy, Django ORM, etc.). Usar solo librerías SQL nativas (`mysql-connector-python`, `pymysql`, etc.) con SQL explícito.

---

## Fase 0: Entorno y Configuración Inicial

- [X] **0.1 Fork y Clonación**
  - [X] Realizar *fork* del repositorio base.
  - [X] Clonar localmente y agregar colaboradores del equipo.
  - [X] Crear y verificar el archivo `.gitignore` (excluir credenciales, `__pycache__`, entorno virtual, etc.).
- [X] **0.2 Despliegue de Servicios Docker**
  - [X] Levantar el contenedor de MySQL.
  - [X] Verificar la correcta inicialización de la BD a través del script `init.sql`.
  - [ ] Configurar contenedores para BDs adicionales (MongoDB, Neo4j, etc.) en `docker-compose.yml` a medida que se requieran.

---

## Fase 1: Modelado Conceptual (MERX)

- [X] **1.1 Ingeniería Inversa sobre BD AquaLife**
  - [X] Analizar la estructura del script `init.sql` y las tablas provistas.
- [X] **1.2 Elaboración del Modelo**
  - [X] Diseñar la propuesta de Modelo Entidad-Relación Extendido (MERX) respetando la concepción vista en clases (usando *diagrams.net* o *Excalidraw*).
- [X] **1.3 Exportación**
  - [X] Exportar el diagrama en formato `.pdf` o `.png`/`.jpg` para la entrega final.

---

## Fase 2: Consultas Analíticas y Lógica en MySQL

### Consultas Básicas / Intermedias

- [X] **3.a Termómetro de la comunidad:** Consulta que calcule la cantidad total de reacciones por publicación (bitácoras, fotos, dudas), con datos del post y autor.
- [X] **3.b Publicaciones mejor recibidas:** Consulta para identificar publicaciones con mayor número de reacciones positivas que negativas, con sus detalles y totales.
- [ ] **3.c Perfil demográfico:** Consulta que analice la distribución de edades en rangos de 10 años (11-20, 21-30,...), retornando cantidad de usuarios y porcentaje.
- [ ] **3.d Tendencias por tipo de agua:** Consulta sobre la variación de bitácoras de mantenimiento según el tipo de agua, identificando especie y categoría más popular.
- [ ] **3.e Vendedores mejor calificados:** Consulta de los Top 5 vendedores (tiendas/criadores) por calificación promedio (incluir total vendidos, promedio, nombre, correo, dirección).

### Lógica Avanzada (Triggers, SP y Métricas Complejas)

- [ ] **3.f Trigger de auditoría de precios:**
  - [ ] Crear la tabla `Historial_Precios` para almacenar auditorías (producto, precio anterior, precio nuevo, fecha, hora, usuario, % de cambio).
  - [ ] Implementar el `TRIGGER` `AFTER UPDATE` sobre la tabla de productos.
- [ ] **3.g Procedimiento Almacenado `sp_analisis_usuario`:**
  - [ ] Crear el SP que tome: `(id_usuario, fecha_inicio, fecha_fin)`.
  - [ ] Retornar: Total publicaciones, reacciones (dadas/recibidas), comentarios, compras, monto gastado, contribuciones, especie más comprada y especie más contribuida.
- [ ] **3.h Análisis de influencers y ventas:**
  - [ ] Identificar Top 5 influencers según puntaje ponderado: Me gusta = 1, Me encanta = 2, Me asombra = 1.5, Comentarios = 2.
  - [ ] Determinar especies de mayor interacción por influencer.
  - [ ] Calcular incremento % de ventas de esas especies (2 semanas posteriores vs 2 semanas anteriores a la publicación).
  - [ ] Calcular la tasa de conversión (% de usuarios que compraron tras reaccionar).
- [ ] **3.i Detección de patrones anómalos en vendedores:**
  - [ ] Detectar variación injustificada de precios (>30%) para misma especie/producto.
  - [ ] Identificar calificaciones polarizadas (muchos 1 y 5, pocos intermedios).
  - [ ] Detectar compradores "exclusivos" que rara vez compran a otros vendedores.
  - [ ] Identificar discrepancias extremas en ventas de un vendedor respecto a sus competidores para la misma especie/producto.
  - [ ] Generar un **"Índice de Sospecha"** ponderado con evidencias específicas.

---

## Fase 3: Conversaciones en Hilos (Tarea 4)

- [ ] **4.a Enfoque Relacional (MySQL)**
  - [ ] Alterar la BD relacional para admitir jerarquía en comentarios (respuestas en árbol/hilos).
  - [ ] Poblar datos de prueba con al menos un hilo de conversación de profundidad/longitud >= 20 subcomentarios.
  - [ ] Escribir consulta SQL (recursiva/WITH RECURSIVE) para extraer la conversación completa a partir del comentario inicial.
- [ ] **4.b Enfoque No Relacional (MongoDB / Neo4j)**
  - [ ] Diseñar el modelo no relacional para representar la misma estructura de hilos utilizando los mismos IDs de comentarios.
  - [ ] Cargar los datos de prueba y resolver la consulta de extracción de la conversación completa.
- [ ] **4.c Análisis Comparativo**
  - [ ] Documentar pros y contras de ambos modelos para incluir en el informe técnico.

---

## Fase 4: Documentación Jerárquica de Especies (Tarea 5)

- [ ] **5.1 Elección del Modelo de Datos**
  - [ ] Seleccionar y justificar el modelo NoSQL (ej. MongoDB) para almacenar Fichas de Especie (documento principal) y documentos secundarios variables (Certificados, Guías, Manuales, etc.) respetando los IDs de especie.
- [ ] **5.2 Implementación y Carga**
  - [ ] Implementar la colección/almacenamiento diseñado.
  - [ ] Insertar datos de prueba: Mínimo 5 fichas de especies, cada una con al menos 3 documentos secundarios de tipos distintos.
- [ ] **5.3 Consulta Jerárquica**
  - [ ] Escribir la consulta que dado un `id_especie` retorne el documento principal y todos los secundarios organizados jerárquicamente.

---

## Fase 5: Desarrollo del Dashboard interactivo en Streamlit (Tarea 6)

- [ ] **6.1 Configuración Base de Streamlit**
  - [ ] Crear estructura en la carpeta `app/` conectada a MySQL/NoSQL usando drivers nativos (`pymysql`/`mysql-connector-python`, `pymongo`, etc.).
- [ ] **6.2 Módulo 1: Selector de Consultas SQL**
  - [ ] Implementar menú desplegable para ejecutar y mostrar en tablas interactivas las consultas de las tareas 3.a a 3.i.
- [ ] **6.3 Módulo 2: Perfil de Usuario (`sp_analisis_usuario`)**
  - [ ] Formulario con inputs para ID de usuario, Fecha Inicio y Fecha Fin que ejecute el procedimiento almacenado y presente los resultados en gráficos/métricas.
- [ ] **6.4 Módulo 3: Gestor de Conversaciones en Hilos**
  - [ ] Interfaz interactiva para navegar por hilos de comentarios y agregar nuevas respuestas.
- [ ] **6.5 Módulo 4: Explorador de Documentos Jerárquicos**
  - [ ] Visor por especie para explorar la Ficha de Especie y sus documentos secundarios en formato organizado.
- [ ] **6.6 Módulo 5: Gestor de Precios y Auditoría (Demo del Trigger)**
  - [ ] Vista para seleccionar productos, cambiar sus precios, ejecutar el `UPDATE` y mostrar automáticamente la actualización en la tabla de auditoría `Historial_Precios`.

---

## Fase 6: Documentación y Empaquetado de Entrega

- [ ] **6.1 Archivo `README.md`**
  - [ ] Redactar guía paso a paso de instalación, configuración del entorno, ejecución con Docker y despliegue de Streamlit.
- [ ] **6.2 Informe Técnico (`Informe_Tecnico.pdf`)**
  - [ ] Incluir la comparación entre el diseño relacional y no relacional de conversaciones (Tarea 4.c).
  - [ ] Incluir la justificación del modelo NoSQL elegido para los documentos jerárquicos de especies (Tarea 5).
  - [ ] Incluir decisiones de diseño técnica relevantes.
- [ ] **6.3 Estructura del Repositorio(puede cambiar con el tiempo)**
  - [ ] Verificar que todo esté en su sitio:
    ```text
    ├── config_database/         # Scripts y configuraciones iniciales de docker
    ├── app/                     # Código fuente de la aplicación Streamlit
    ├── docs/                    # Imagen/PDF del MERX, Informe Técnico PDF y orientación del proyecto
    ├── docker-compose.yml       # Fichero Docker actualizado con todos los servicios
    ├── README.md                # Instrucciones del proyecto
    └── .gitignore               # Exclusiones de Git
    ```
- [ ] **6.4 Revisión Final de Defensa**
  - [ ] Probar todo el flujo en una instalación limpia y en diferentes SO's.
  - [ ] Asegurar acceso al repositorio para los profesores.
