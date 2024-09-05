# Docker

---

> first course Docker - Basics
> > [es](https://aulasoftwarelibre.github.io/taller-de-docker/introduction/#conceptos-basicos)
> > [en](https://docs.docker.com/guides/docker-overview/)

# Basics

Docker is a platform for containerizing applications. Containers run on the
kernel isolated from other processes and tend to have better performance than
virtualisation.

## Architecture

### Daemon

Principal process that listens for the API and manages images, containers,
networks and volumes.

### Client

Tool for interacting with the docker system.

### Registry

Where images are store, [Docker Hub](https://hub.docker.com/) is the primary
repository.

## Objects

## Images

Blue-print for constructing the container.

### Running Images

```bash
# starting an image
docker run image:version
# conection container port to host port
docker run -p hport:cport image:version
```

`run` = `create` `start` `attach`.

Port protocol can be declared with `port/protocol`.

### Downloading Images

```bash
docker pull image:version
```

If no version specified default to latest

### Listing Images

```bash
docker images
```

### Removing Images

```bash
docker rmi image:version
```

## Containers

Runnable instance of an image.

A container can be referenced by id or name.

Do to limitation on early version of docker some commands that interact with
containers have multiple names, and can be use interchangeably.

| Old            | New                      |
| -------------- | ------------------------ |
| docker run     | docker container run     |
| docker start   | docker container start   |
| docker stop    | docker container stop    |
| docker rm      | docker container rm      |
| docker inspect | docker container inspect |
| docker exec    | docker container exec    |

### Listing

```bash
# shows running containers
docker container ls
# shows all containers
docker container ls -a
```

### Executing Commands

```bash
# run command on container
docker exec name cmd
# specifi a working directory
docker exec -w path name cmd
```

### Starting a Container

```bash
docker start name
```

### stopping a Container

```bash
docker stop name
```

### Removing a Container

```bash
docker rm name
```

## Data Persistence

- docker volumes
- mounting host directory
- system memory

### Creating Volumes

```bash
docker volume create name
```

### List Volumes

```bash
docker volume ls
```

### See Metadata

```bash
docker volume inspect name
```

### Deleting Volumes

```bash
docker volume rm
```

# Exercise

## WordPress with docker

### Using MariaDB

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
    -e MYSQL_PASSWORD=secret mariadb:10
```

-d for executing in background
-e for setting environment variables for config
--mount mounting volume for persisting data

### WordPress Container

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

## Docker Compose

### Compose File

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

### Start Service

```bash
docker compose up -d
```

### List services on compose file

```bash
docker compose ps
```

### Stopping Services

```bash
docker compose stop
```

### Removing Services

```bash
# delete containers but not volumes
docker compose down
# delete with volumes
docker compose down -v
```

### Extra

When rebooting the PC the container will be stopped. You can restart them with
`docker start` or `docker compose start`. However if you want to conserve the
same state as before reboot we can use the `restart` argument.

```yaml
restart: unless-stopped
```

```bash
--restrt unless-stopped
```

Other values: `no` (default), `always` and `on-failure`


# Custom Images

## Dockerfile

Instructions on how to construct the docker image.

```Dokerfile
FORM img
COPY src trg
RUN cmd
```

| Directive  | Description                                  |
| ---------- | -------------------------------------------- |
| FROM       | Base image                                   |
| COPY       | Copy  from build context to image            |
| RUN        | Execute command when creating image          |
| CMD        | Execute command when running a container     |
| ENTRYPOINT | Start of command to execute when running     |
| ADD        | Same as COPY but allows URL and extract tars |
| ENV        | Set environment variable                     |
| EXPOSE     | Maps ports                                   |
| VOLUME     | Defines volumes (shared if path is provided) |
| WORKDIR    | Set working directory                        |

For more directives go to [official
documentation](https://docs.docker.com/engine/reference/builder/)

```bash
docker build -t img:ver path
```

### Docker Compose

We can provide a build context instead of an image with the `build` param.

```yaml
services:
    service:
        build: path
```

## Load Balancing

Do not expose service with `ports` instead use `traefik` service.

Example:

```ymal
services:
    web:
        build: .
        labels:
        - "traefik.enable=true"
        - "traefik.http.routers.web.rule=Host(`localhost`)"
        - "traefik.http.routers.web.entrypoints=web"
        - "traefik.http.services.web.loadbalancer.server.port=80"
    redis:
        image: redis
        volumes:
            - "./data:/data"
        command: redis-server --appendonly yes
        labels:
        - "traefik.enable=false"
    traefik:
        image: traefik:v2.3
        command:
        - "--log.level=DEBUG"
        - "--api.insecure=true"
        - "--providers.docker=true"
        - "--providers.docker.exposedByDefault=false"
        - "--entrypoints.web.address=:4000"
        ports:
        - "4000:4000" # Exponer Traefik en el puerto 4000 de localhost
        - "8080:8080" # Dashboard de Traefik
        volumes:
        - "/var/run/docker.sock:/var/run/docker.sock"
        labels:
        - "traefik.enable=true"
```

```bash
docker compose up -d --scale web=5
```

Not a correct way of load balancing as all containers are on the same machine.
For demonstration purposes only.

## Sharing Images

1. Create an account on the [official docker repository](https://hub.docker.com/).
2. Select "_Create Repository +_".
3. Fill at least the name field on the form.
4. Connect the docker client with `docker login`.
5. Build image with namespace and repository name:
   `docker build -t namespace/repository path`.
6. Upload image `docker push namespace/repository`.

By default namespace is the same as username.

# Extra (Tricks)

## Portainer

Web interface container manager.

```yaml
services:
    portainer:
        image: portainer/portainer
        command: -H unix:///var/run/docker.sock
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
            - portainer_data:/data
        ports:
            - 127.0.0.1:9000:9000
volumes:
    portainer_data:
```

> **NOTE**: portainer/portainer is deprecated use portainer/portainer-ce.

## Cleaning

Remove unused objects.

```bash
docker system prune
```

Remove volumes not associated with any container.

```bash
docker volume rm$( docker volume ls -q -f "dangling=true")
```

Remove containers that have stop their execution

```bash
docker rm $(docker ps -q -f "status=exited")
```

Remove images without tags.

```bash
docker rmi $(docker images -q -f "dangling=true")
```

## Backups

Backup:

```bash
docker run --rm -v /tmp:/backip \
    --volumes-from <container-name> \
    busybox tar -cvf /backup/backup.tar <path-to-data>
```

Restore:

```bash
docker run --rm -v /tmp:/backup \
    --volumes-form <container-name> \
    busybox tar -xvf /backup/backup.tar <path-to-data>
```

# Committing Containers to Images

> second course Docker

```bash
# commit without a name
docker commit <container>
# commit with name
docker commit <container> <name>
```

## Tagging images

```bash
docker tag <image-id> tag
```

## Attaching to Container

```bash
docker attach <container>
```

You can exit a container without stopping it with `^P ^Q`.

## Logging

```bash
docker log <container>
```

## Kill Container

Similar to `docker stop` but send `SIGKILL` instead of `SIGTERM` resulting
in unsafe exits.

```bash
docker kill <container>
```

## Pausing Containers

```bash
docker pause <container>
```

## Port Information

```bash
docker port <container>
```

# Run Options

| Option | Description                                          |
| ------ | ---------------------------------------------------- |
| --rm   | Removes container on exit                            |
| -t     | Allocate a pseudo TTY (better syntax on interactive) |
| -i     | For interacting with container console               |
| -d     | Run container in background                          |
| --name | Set container name                                   |
| --net  | Specify network to connect to                        |
| -v     | Bind mounts a volume                                 |

## Resource Constraints

### Memory

```bash
docker run --memory <bytes> <image>
```

### CPU

```bash
# relative to other containers
docker run --cpu-shares <num>
# limit CFS (Completely Fair Scheduler) quota
docker run --cpu-quota
```

# Networks

## Defaults

| Network | Description              |
| ------- | ------------------------ |
| bridge  | No network specification |
| host    | No network isolation     |
| none    | No networking            |

## List

```bash
docker network ls
```

## Create

```bash
docker network create <name>
```

## Connections

```bash
# conects container to network
docker network connect <network> <container>
# disconects container form network
docker network disconnect <network> <container>
```

### Listing Connections

```bash
# list container on network
docker network inspect <network> -f "{{json .Containers }}"
# list networks a container is attached to
docker inspect <container> -f "{{json .NetworkSettings.Networks }}"
```

# Legacy Linking

- Connects all ports
- Only one way
- Same with Secret environment variables
- Depends on startup order

```bash
docker run --link <running-container> <image>
```

# Search

```bash
docker search <image>
```

# Dockerfiles Cache

When building docker caches each step. Every line is run independently.
Environment variables persist if used the ENV command to set them.

## Command Forms

### Shell Form

```dockerfile
cmd args
```

### Exec Form

```dockerfile
["path-to-cmd", "args"]
```

# Multi-stage builds

Use multiple `FROM` statements for different stages of the build process,
copying form pass stages only what you want in the final image.

# Docker socket

`/var/run/docker.sock`

# Saving Images

```bash
# backup images to file
docker save -o arch.tar.gz <images>
# load images from file
docker load -i arch.tar.gz
```

# Orchestration System

## Docker Compose

- Single machine coordination
- Designed for testing and development
- All in one command

## Kubernetes

- Pods group containers together
- Services make pods available to others
- Very flexible overlay networking 
- Built in discovery service

## EC2

- Task definition (set of containers that always run together)
- Ensures task are running all the time
- Works well with amazon services

# Containers vs Virtual Machines

## Containers

- Run in runtime
- Alongside OS
- not OS configuration
- usually one app at a time

## Virtual Machines

- Run on hypervisor
- Hardware emulation
- Require OS configuration
- Many apps at once

# Container anatomy

## Namespaces

Different views of system.

| Namespace | Description                |
| --------- | -------------------------- |
| USERNS    | User list                  |
| MOUNT     | Access to file system      |
| NET       | Network communication      |
| IPC       | Interprocess communication |
| TIME      | Change time                |
| PID       | Process ID management      |
| CGROUP    | Create control groups      |
| UTC       | Create host/domain names   |

> **NOTE:** TIME namespace not supported on docker. 

## Control groups

Restrict resources a container can use.

# Docker Compose

> third course

Docker configuration as code.

Designed for:

- Local development
- Staging server
- Continuous integration testing environment

For production environments use clustering tools like kubernetes.

## V1 vs V2

V2 is integrated into docker cli platform and let's you use shared flags on the
root docker command.

### Service container names

V1 uses `_` as word separator and V2 uses `-`.

`--compatibility` or `COMPOSE_COMPATIBILITY` to set V2 word separator as `_`.

### Command-line flags and subcommands

#### Unsupported

- `docker-compose scale`. Use `docker compose up --scale`.
- `docker-compose rm --all`.

## Structure

```yaml
version:  "<ver>"

services:
    <service>:
        build: path
    <service>:
        image: <image>
```

## Commands

### Starting

```bash
# build create and start all containers
docker compose up
# for spesific steps
docker compose build
docker compose create
docker compose start
# start only one service and its dependencies
docker compose up <service>
```

### Stopping

```bash
# stop and delete containers images and artifacts
docker compose down
# stop and delete as individual steps
docker compose stop
docker compose rm
```

### Restarting

```bash
# same as stop then start
docker compose restart
```

## Build Args

`build: <path>` changes to:

```yaml
services:
    <service>:
        build:
            context: <path>
            args:
                - <arg1>=<val1>
        	- <arg2>=<val2>
```

## Environment Variable

```yaml
services:
    <service>:
        environment:
            - <env1>=<val>
    	- <env2>
```

No value passes the host variable

### env file

```yaml
services:
    <service>:
        env_file:
            - <path>
```

## Volumes

```bash
# deletes named volumes
docker compose down --volumes
```

### nameless

```yaml
serives:
    <service>:
        volumes:
            - <src>:<target1>:<mode>
            - <target2>
```

If no <src> docker makes volume automatically.

<mode> can be rw (defaul) or ro.

### named

```yaml
volumes:
    <volume>:
```

Can use <volume> instead of path in <scr>

### Syntax

#### short syntax

```yaml
<src>:<target>:<mode>
```

#### Long syntax

```yaml
type: volume
source: <src>
target: <target>
read_only: (true|false)
```

## Ports

```yaml
services:
    <service>
        port:
	    - "<hport>:<cport>"
```

## Startup Order

Starts and stops on dependency order.

```ymal
services:
    <service>:
        depends_on:
	    - <other-service>
```

Starting service by name also starts its dependencies.

## Service Profiles

```ymal
services:
    <service>:
        profiles:
	    - <profile>
```

If not profile specified, it is included with every other service profile.

```bash
# run only defualt profile services
docker compose up
# run only prifile services
docker compose --profile <profile> <cmd>
```

## Multiple Compose File

- Distinct desired behaviors that do no coincide
- Different environments

`docker compose` reads from `docker-compose.ymal` and
`docker-compose.override.yaml`, merging its contents with preference to
override.

```bash
docker compose -f docker-compose.yaml -f docker-compose.<override>.yaml <cmd>
```

### distinct overrides

Replace override in file name.

`docker-compose.<name>.ymal`

> **NOTE:** first field of `-f` doesn't need to be docker-compose.yaml.

## Environment Variables

Use ${VAR} to replace within the docker file.

#### Default

- `${VAR:-default}`: `VAR` if set and not-empty, otherwise default.
- `${VAR-default}`: `VAR` if set , otherwise default.

#### Required

- `${VAR:?error}`: `VAR` if set and not-empty, otherwise exit with error.
- `${VAR?error}`: `VAR` if set , otherwise exit with error.

#### Alternative

- `${VAR:+replacement}`: replacement if `VAR` is set and not-empty, otherwise empty.
- `${VAR+replacement}`: replacement if `VAR` is set , otherwise empty.

### Variable defaults

docker compose automatically use declaration in the shell, variables form .env
file or in:

```bash
docker compose --env-file <path>
```

# Extra

> Extra course

## Space

```bash
docker system prune
```

## Stat

```bash
docker stats <container>
docker top <continer>
```

