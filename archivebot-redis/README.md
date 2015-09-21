# Docker Archivebot Redis

Docker image for the [Archiveteam's](http://www.archiveteam.org/) [ArchiveBot](http://www.archiveteam.org/index.php?title=ArchiveBot) redis connection.

## Usage
1. Clone this repository
2. Change into the repository directory
`cd docker-archivebot-redis`
3. Build the docker image
`docker build -t archivebot-redis .`
4. Run the docker image
`docker run -it -rm --name archivebot-redis archivebot-redis`

## Configuration


### Mapping UID and GID
The uploader is run as the user and group `archivebot` with UID/GID `1000`. To map the `archivebot` user to a different UID set the `USERMAP_UID` and `USERMAP_GID` environement variables when running the image.

`docker run -it -rm --name archivebot-uploader -e "USERMAP_UID=$(id -u archivebot)" -e "USERMAP_GID=$(id -g archivebot)" archivebot-uploader`
