# Basic Dockerfile with MongoDB, PHP7, Apache2

## Installation 

```shell
docker build -t="mongo-apache2" .

docker run --name=your-container-name -p8080:80 -v /your-project-path:/var/www/project -d -i -t mongo-apache2

// Load mongod 

docker exec -ti your-container-name /bin/bash

mongod

```