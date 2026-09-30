# Para que inicien la base de datos que estaremos usando

- Le puse la default seed como 33 para no tener la que el profe da por defecto (42)
- Todos los comandos son basados en linux, no se como pinche en windows o macos]
- Tambien hice un todo para ir marcando lo que vayamos haciendo, revisar el archivo`todo's.md`

# Comandos para que empiecen a trastear xD

Para iniciar el proyecto por ahora solo estaremos usando mysql asi que no es necesario cargar los demas SGBD(mongodb, neo4j etc) por lo que deben usar el siguiente comando para empezar a usar la bd

### 1. Clonar el repo y configurar git

entre las comillas deben poner sus credenciales, ejemplo github_username debe ser "fcd06" para fabian

```Shell
git clone https://github.com/fcd06/AquaLife_Database
git config --global user.name "github_username"
git config --global user.email "email_asociado_github"
```

### 2. Para verificar que estan bien configurados usen  [[]]

```Shell
git config user.name
git config user.email
```

Les deberia salir algo como:

10Y6 -> su username de github
alexmanuel1900@gmail.com -> su email asegurense que es el que tienen asociado a github

### 3. Para iniciar el contenedor

Asegurense de estar en la raiz del proyecto

```Shell
cd Aqualife_Database
```

Solo iniciamos mysqllab por ahora es el unico que usamos ya que aun no vemos otros tipos de bases de datos

```Shell
docker compose build --progress=plain      
docker compose up -d mysqllab
```

Tienen que tener internet pa esto, tengan cuidado son un poco menos de 200 mega, este paso nadamas lo hacen la primera vez

### 4. Luego de esto en la terminal ya pueden empezar a usar la bd con el siguiente comando

```Shell
 docker exec -it aqualife_mysql mysql -u root -p
```

en la terminal les deberia salir algo como `Enter password: ahi escriben root`y ya tienen acceso a la consola de mysql para hacer lo que quieran

El prompt de la consola deberia verse algo como:

```
mysql>
```

Ahi ya pueden tirar codigo sql

```SQL
SHOW DATABASES; --Para ver las bases de datos en el contenedor
USE AquaLife; --Para trabajar sobre la base de datos del proyecto
CREATE DATABASE <db_name>; --Para que crear una base de datos en la que cacharrear
```

### 5. Por ultimo si quieren reiniciar los datos porque eliminaron alguna tabla o metieron en pie cacharreando

Para eliminar la base de datos, la flag -v elimina los volumenes para que pueda ser regenerada de 0 la bd

```Shell
docker compose down -v
```

Para volver a iniciar la base de datos

```Shell
docker compose build --progress=plain      
docker compose up -d mysqllab
```

Recuerden cada que quieran trastear en la base de datos hacer el comando del paso 4 en la terminal

# HAGAN LO SIGUIENTE A MI ME SIRVIO

el lio era que en docker-compose.yml tenia un limite maximo de mb por paquete, y como eran millones de filas que se insertaban de un palo daba error y cambie el .yml, ahora deberia funcionar, demora un poco(bastante) en ponerse ready

```Shell
# 1. Borrar todo
docker compose down -v

# 2. Iniciar y mirar el log 
docker compose up -d --build mysqllab
sleep 5 

# 3. Sigue el log en tiempo real hasta que vean "Server is ready"
docker logs -f aqualife_mysql --tail=100
```

Cuando les salga algo tipo, el siguiente mensaje prueben las tablas

```
2026-09-26 22:50:45+00:00 [Note] [Entrypoint]: /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/zzz-cleanup.sh
rm: cannot remove '/docker-entrypoint-initdb.d/init.sql': Permission denied
2026-09-26 22:50:45+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
2026-09-26 22:50:46+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2026-09-26 22:50:46+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.46-1.el9 started.
'/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
2026-09-26T22:50:46.868294Z 0 [Warning] [MY-011068] [Server] The syntax '--skip-host-cache' is deprecated and will be removed in a future release. Please use SET GLOBAL host_cache_size=0 instead.
2026-09-26T22:50:46.874838Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.46) starting as process 1
2026-09-26T22:50:46.890200Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2026-09-26T22:50:50.325548Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2026-09-26T22:50:51.123604Z 0 [System] [MY-010229] [Server] Starting XA crash recovery...
2026-09-26T22:50:51.132942Z 0 [System] [MY-010232] [Server] XA crash recovery finished.
2026-09-26T22:50:51.751702Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
2026-09-26T22:50:51.751775Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
2026-09-26T22:50:51.756850Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
2026-09-26T22:50:51.801117Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
2026-09-26T22:50:51.801322Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

1
