---
title: Docker
author: Alexander Zerpa
theme: Madrid
aspectratio: 169
header-includes: |
    \usecolortheme[RGB={45,155,240}]{structure}

    \setbeamercolor{frametitle}{bg=gray!00!white,fg=structure.fg}
    
    \setbeamercolor*{titlelike}{parent=palette primary}

    \setbeamertemplate{footline}[frame number]{}

    \setbeamertemplate{navigation symbols}{}

    \setbeamertemplate{footline}{}
---

# Docker

Docker is a platform for containerizing applications. Containers run
on the kernel, isolated from other processes and tend to have better
performance than virtualisation.

#### Containers vs Virtual Machines

::: columns
:::: column

##### Containers

- Run in runtime
- Alongside OS
- Not OS configuration
- Usually one app at a time

::::
:::: column

##### Virtual Machines

- Run on hypervisor
- Hardware emulation
- Require OS configuration
- Many apps at once

::::
:::

### Architecture

::: columns
:::: {.column width=30%}

#### Client

Tool for interacting with the docker system.

::::
:::: {.column width=30%}

#### Daemon

Principal process that listens for the API and manages images, containers,
networks and volumes.

::::
:::: {.column width=30%}

#### Registry

Where images are stored, [Docker Hub](https://hub.docker.com/) is the
primary repository.

::::
:::

# Objects

## Images

Blue-print for constructing the container.

::: columns
:::: {.column width=50%}

#### Making Images of Containers

```bash
docker commit <container> <image>
```

#### Renaming Images

```bash
docker tag <image> <repo>:<tag>
```

#### Saving Images

```bash
docker save -o <arch>.tar.gz <images>
```

::::
:::: {.column width=45%}

#### Listing Images

```bash
docker images
```

#### Removing Images

```bash
docker rmi <repo>:<tag>
```

#### Loading Images

```bash
docker load -i <arch>.tar.gz
```

::::
:::

\ 

> **NOTE:** When `<tag>` is not specified `latest` is used.

### Building Images

When building, docker caches each step. Every line is run independently.

::: columns
:::: {.column width=45%}

#### Dockerfile Instructions

| Directive  | Description                 |
| ---------- | --------------------------- |
| FROM       | Base image                  |
| COPY       | Copy  from build context    |
| RUN        | Execute command             |
| CMD        | Cmd for container to run    |
| ENTRYPOINT | Start of command            |
| ENV        | Set environment variable    |
| EXPOSE     | Maps ports                  |
| VOLUME     | Defines volumes             |
| WORKDIR    | Set working directory       |

::::
:::: {.column width=50%}

#### Dockerfile Example

```dokerfile
FORM img
COPY src trg
RUN cmd
```

#### Building

```bash
docker build -t <repo>:<tag> <path>
```

#### Multi-stage builds

Use multiple `FROM` statements for different stages of the build process,
copying form pass stages only what you want in the final image.

::::
:::

### Remote Images

If docker cant find a Image locally it will try to pull it from the official
repo.

::: columns
:::: {.column width=40%}

#### Sharing Images

1. Create an account on the [official docker repository](https://hub.docker.com/).
2. Select "_Create Repository +_".
3. Fill at least the name field on the form.
4. Connect the docker client.
5. Build image with namespace and repository name.
6. Upload image.

::::
:::: {.column width=55%}

#### Downloading Images

```bash
docker pull <repo>:<tag>
```

#### Connect docker client

```bash
docker login
```

#### Upload Images

```bash
docker push <namespace>/<repo>:<tag>
```

::::
:::

By default `<namespace>` is the same as username.

## Containers

Runnable instance of an image.
A container can be referenced by id or name.

::: columns
:::: column

#### Namespaces

Different views of system.

| Namespace | Description                   |
| --------- | ----------------------------- |
| USERNS    | User list                     |
| MOUNT     | Access to file system         |
| NET       | Network communication         |
| IPC       | Interprocess communication    |
| TIME      | Change time *(not supported)* |
| PID       | Process ID management         |
| CGROUP    | Create control groups         |
| UTC       | Create host/domain names      |

::::
:::: column

#### Control groups

Restrict resources a container can use.

#### Command names

| Old            | New                      |
| -------------- | ------------------------ |
| docker run     | docker container run     |
| docker start   | docker container start   |
| docker stop    | docker container stop    |
| docker rm      | docker container rm      |
| docker inspect | docker container inspect |
| docker exec    | docker container exec    |

::::
:::

### Managing Containers

::: columns
:::: {.column width=60%}

#### Creating Containers

```bash
# creates an image
docker container create <image>
# creates an image with set name
docker container create <image> --name <name>
```

#### Listing

```bash
# shows running containers
docker container ls
# shows all containers
docker container ls -a
```

#### Removing a Container

```bash
docker rm <container>
```
::::
:::: {.column width=35%}

#### Starting a Container

```bash
docker start <container>
```

#### Stopping a Container

```bash
docker stop <container>
```

#### Kill Container

Similar to `docker stop` but send `SIGKILL` instead of `SIGTERM`.

#####

```bash
docker kill <container>
```

#### Pausing Containers

```bash
docker pause <container>
```

::::
:::

### Running Images

::: columns
:::: column

#### Run Options

| Option    | Description                    |
| --------- | ------------------------------ |
| -t        | Allocate a pseudo TTY          |
| -i        | For interacting with console   |
| -d        | Run container in background    |
| -e        | Sets environment variables     |
| -v        | Bind mounts a volume           |
| -p        | Links container and host ports |
| --rm      | Removes container on exit      |
| --name    | Set container name             |
| --net     | Specify network to connect to  |
| --mount   | Attach filesystem mount        |

::::
:::: column

#### Run Command

```bash
docker run <repo>:<tag>
```

`run` = `create` + `start` + `attach`.

#### Resource Constraints

##### Memory

```bash
docker run --memory <bytes> <image>
```

##### CPU

```bash
# relative to other containers
docker run --cpu-shares <num>
# limit CFS quota
docker run --cpu-quota
```

::::
:::

### Interacting with a Container

::: columns
:::: {.column width=50%}

#### Executing Commands

```bash
# run command on container
docker exec <container> <cmd>
# specifi a working directory
docker exec -w <path> <container> <cmd>
```

#### Attaching to Container

You can exit a container without stopping it with `^P ^Q`.

#####
```bash
docker attach <container>
```

#### Logging

```bash
docker log <container>
```

::::
:::: {.column width=45%}

#### Legacy Linking

- Connects all ports
- Only one way
- Same with Secret environment variables
- Depends on startup order

#####
```bash
docker run --link <container> <image>
```

#### Port Information

```bash
docker port <container>
```

::::
:::

## Volumes

Persistent data for containers.

::: columns
:::: column

#### Creating Volumes

```bash
docker volume create <volume>
```

#### Deleting Volumes

```bash
docker volume rm <volume>
```

::::
:::: column

#### List Volumes

```bash
docker volume ls
```

#### See Metadata

```bash
docker volume inspect <volume>
```

::::
:::

### Backups

#### Backup

```bash
docker run --rm -v /tmp:/backip \
    --volumes-from <container-name> \
    busybox tar -cvf /backup/backup.tar <path-to-data>
```

#### Restore

```bash
docker run --rm -v /tmp:/backup \
    --volumes-form <container-name> \
    busybox tar -xvf /backup/backup.tar <path-to-data>
```

## Networks

Virtual connections between containers and external devices.

::: columns
:::: column

#### Defaults

| Network | Description              |
| ------- | ------------------------ |
| bridge  | No network specification |
| host    | No network isolation     |
| none    | No networking            |

::::
:::: column

#### List

```bash
docker network ls
```

#### Create

```bash
docker network create <name>
```

::::
:::

### Connections

#### Connecting Containers

```bash
# conects container to network
docker network connect <network> <container>
# disconects container form network
docker network disconnect <network> <container>
```

#### Listing Connections

```bash
# list container on network
docker network inspect <network> -f "{{json .Containers }}"
# list networks a container is attached to
docker inspect <container> -f "{{json .NetworkSettings.Networks }}"
```

# Docker Compose

Docker configuration as code.

Designed for:

- Local development
- Staging server
- Continuous integration testing environment

For production environments use clustering tools like kubernetes.

### V1 vs V2

V2 is integrated into docker cli platform and let's you use shared flags on the
root docker command.

#### Service container names

V1 uses `_` as word separator and V2 uses `-`.

`--compatibility` or `COMPOSE_COMPATIBILITY` to set V2 word separator as `_`.

#### Unsupported Command-line flags and subcommands

- `docker-compose scale`. Use `docker compose up --scale`.
- `docker-compose rm --all`.

### Commands

::: columns
:::: {.column width=50%}

#### Starting

```bash
# build create and start containers
docker compose up
# for spesific steps
docker compose build
docker compose create
docker compose start
# start only service and dependencies
docker compose up <service>
```

::::
:::: {.column width=45%}

#### Stopping

```bash
# stop and delete services
docker compose down
# same as down
docker compose stop
docker compose rm
```

#### Restarting

```bash
# same as stop then start
docker compose restart
```

::::
:::

## Structure

### Services

::: columns
:::: column

- Configuration to be applied to each service container.
- Can be build or use and existing image.

::::
:::: column

####
```yaml
services:
    <service>:
        build: <path>
    <service>:
        image: <image>
```

::::
:::

### Configuring Images

::: columns
:::: column

Configurations and arguments depend on the image. Read image documentation to
know what to use.

#### Build Args

`build: <path>` changes to:

#####
```yaml
services:
    <service>:
        build:
            context: <path>
            args:
                - <arg1>=<val1>
                - <arg2>=<val2>
```

::::
:::: column

#### Environment Variable

No value passes the host variable

#####
```yaml
services:
    <service>:
        environment:
            - <env1>=<val>
    	    - <env2>
```

#### env file

```yaml
services:
    <service>:
        env_file:
            - <path>
```

::::
:::

### Volumes

::: columns
:::: column

####
```bash
# deletes named volumes
docker compose down --volumes
```

#### Syntax

##### short syntax

```yaml
<src>:<target>:<mode>
```

##### Long syntax

```yaml
type: volume
source: <src>
target: <target>
read_only: (true|false)
```

::::
:::: column

#### nameless

```yaml
serives:
    <service>:
        volumes:
            - <src>:<target1>:<mode>
            - <target2>
```

If no `<src>` docker makes volume automatically.

`<mode>` can be `rw` (defaul) or `ro`.

#### named

```yaml
volumes:
    <volume>:
```

Can use `<volume>` instead of path in `<scr>`.

::::
:::

### Ports

::: columns
:::: column

####
```yaml
services:
    <service>
        port:
	    - "<hport>:<cport>"
```

::::
:::: column

> **NOTE:** Port protocol can be declared with `port/protocol`.

::::
:::

### Start Options

::: columns
:::: {.column width=40%}

#### Startup Order

Starts and stops on dependency order.

#####
```yaml
services:
    <service>:
        depends_on:
	    - <other-service>
```

####
Starting service by name also starts its dependencies.

#####
```bash
docker compose up <service>
```

::::
:::: {.column width=55%}

#### Service Profiles

If not profile specified, it is included in default and starts with every other service profile.

#####
```yaml
services:
    <service>:
        profiles:
	    - <profile>
```

#####
```bash
## run only defualt profile services
docker compose up
## run only prifile services
docker compose --profile <profile> <cmd>
```

::::
:::

### Multiple Compose File

- Distinct desired behaviors that do no coincide
- Different environments

`docker compose` reads from `docker-compose.ymal` and
`docker-compose.override.yaml`, merging its contents with preference to
override.

####
```bash
docker compose -f docker-compose.yaml -f docker-compose.<override>.yaml <cmd>
```

#### distinct overrides

Replace override in file name.

`docker-compose.<name>.ymal`

\ 

> **NOTE:** first field of `-f` doesn't need to be docker-compose.yaml.

### Environment Variables

Use ${VAR} to replace within the docker file.

::: columns
:::: {.column width=30%}

##### Default

- `${VAR:-default}`: \
    `VAR` if set and not-empty, otherwise default.
- `${VAR-default}`: \
    `VAR` if set, otherwise default.

::::
:::: {.column width=30%}

##### Required

- `${VAR:?error}`: \
    `VAR` if set and not-empty, otherwise exit with error.
- `${VAR?error}`: \
    `VAR` if set, otherwise exit with error.

::::
:::: {.column width=31%}

##### Alternative

- `${VAR:+replacement}`: \
    replacement if `VAR` is set and not-empty, otherwise empty.
- `${VAR+replacement}`: \
    replacement if `VAR` is set, otherwise empty.

::::
:::

#### Variable defaults

docker compose automatically use declaration in the shell, variables form
`.env` file or in:

#####
```bash
docker compose --env-file <path>
```

# WordPress with MariaDB

## Using Docker

### Database Container

#### Creating Volume

```bash
docker volume create wordpress-db
```

#### Creating Container

```bash
docker run -d --name wordpress-db \
    --mount source=wordpress-db,target=/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=wordpress \
    -e MYSQL_USER=manager \
    -e MYSQL_PASSWORD=secret \
    mariadb:10
```

### Wordpress Container

#### Working Space

For editing files and modifying behaviour.

```bash
mkdir -p Sites/wordpress/target && cd Sites/wordpress
```

#### Running docker

```bash
docker run -d --name wordpress \
    --link wordpress-db:mysql \
    --mount type=bind,source="$(pwd)"/target,target=/var/www/html \
    -e WORDPRESS_DB_USER=manager \
    -e WORDPRESS_DB_PASSWORD=secret \
    -p 8080:80 \
    wordpress:6
```

## Using Docker Compose

#### Compose File

::: columns
:::: {.column width=45%}

```yaml
services:
    db:
        image: mariadb:10
	volumes:
	    - data:/var/lib/mysql
	environment:
	    - MYSQL_ROOT_PASSWORD=secret
	    - MYSQL_DATABASE=wordpress
	    - MYSQL_USER=manager
	    - MYSQL_PASSWORD=secret
    web:
        image: wordpress:6
	depends_on:
	    - db
```

::::
:::: {.column width=50%}

```yaml
	volumes:
	    - ./target:/var/www/html
	environment:
	    - WORDPRESS_DB_USER=manager
	    - WORDPRESS_DB_PASSWORD=secret
	    - WORDPRESS_DB_HOST=db
	    - WORDPRESS_DB_NAME=wordpress
	ports:
	    - 8080:80

volumes:
    data:
```

#### Start Service

```bash
docker compose up -d
```
::::
:::

