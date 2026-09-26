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

```Shell
# 1. Borrar todo
docker compose down -v

# 2. Iniciar y mirar el log 
docker compose up -d --build mysqllab
sleep 5 

# 3. Sigue el log en tiempo real hasta que vean "Server is ready"
docker logs -f aqualife_mysql --tail=100
```
