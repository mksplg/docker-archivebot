# Docker Archivebot
Docker images for the [Archiveteam's](http://www.archiveteam.org/) [ArchiveBot](http://www.archiveteam.org/index.php?title=ArchiveBot).

## Startup commands
To show startup commands, run the images with command `app:help`.
```
docker run -it -rm --name archivebot-pipeline archivebot-pipeline app:help
```

## User configuration
All containers are run as the container user and group `archivebot` with UID/GID `1000`. To map the `archivebot` user to a different host UID/GID set the `USERMAP_UID` and `USERMAP_GID` environement variables when running the image. If `USERMAP_GID` is not set, `USERMAP_UID` is used for both UID and GID.

For example to use the *hosts* UID and GID of the user `archivebot` use
```
docker run -it -rm --name archivebot-pipeline -e "USERMAP_UID=$(id -u archivebot)" -e "USERMAP_GID=$(id -g archivebot)" archivebot-pipeline
```


## Docker Archivebot Redis

The Archivebot Pipeline requests job from a redis database hosted by the ArchiveTeam. Redis is accessed through an SSH tunnel. Check the [ArchiveBot install instructions](https://github.com/ArchiveTeam/ArchiveBot/blob/master/INSTALL.pipeline#L28) for details how to get access.

## Usage
1. Change into the directory
`cd archivebot-redis`
2. Build the docker image
`docker build -t archivebot-redis .`
3. Run the docker image
`docker run --name archivebot-redis -it --rm -e "USERMAP_UID=$(id -u archivebot)" -e "USERMAP_GID=$(id -g archivebot)" -e "SSH_USER=YOURUSERHERE" -v "/srv/docker/archivebot/id_rsa:/home/archivebot/.ssh/id_rsa:ro" -p docker-archivebot-redis`

## Configuration
Some settings can be overridden from the default values by setting environment variables in the container. Typically the only thing to change is the ssh username
`SSH_USER=YOURUSERHERE`

To specify a private key for authentication mount it into the container as a volume
` -v "/srv/docker/archivebot/id_rsa:/home/archivebot/.ssh/id_rsa:ro"`

Aditionally the ssh host and port can be specified
`SSH_HOST=archivebot-redis.com`
`SSH_PORT=10022`


## Docker Archivebot Pipeline
The Archivebot Pipeline communicating with redis through docker-archivebot-redis and handles processing archive jobs.

## Usage
1. Change into the pipeline directory
`cd archivebot-pipeline`
2. Build the docker image
`docker build -t archivebot-pipeline .`
3. Run the docker image
`docker run -it --rm --name archivebot-pipeline -v "/srv/docker/archivebot/warcs4fos:/home/archivebot/warcs4fos" --link archivebot-redis:redis archivebot-pipeline`

## Configuration
To specify a directory where the pipeline puts finished warcs mount it into the container as a volume
` -v "/srv/docker/archivebot/warcs4fos:/home/archivebot/warcs4fos"`


## Docker Archivebot Uploader
The Archivebot uploader uploads finished warcs to an rsync server hosted by ArchiveTeam.

## Usage
1. Change into the repository directory
`cd archivebot-uploader`
2. Build the docker image
`docker build -t archivebot-uploader .`
3. Run the docker image
`docker run -it --rm --name archivebot-uploader -v "/srv/docker/archivebot/warcs4fos:/home/archivebot/warcs4fos" archivebot-uploader`

## Configuration
To specify a directory where the uploader looks for warcs to upload mount it into the container as a volume
` -v "/srv/docker/archivebot/warcs4fos:/home/archivebot/warcs4fos"`