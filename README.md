# devenv
 
Alternative way to manage your shared dev environement resources with docker.


# What ?

Want to spin up a specific, pre configured, version of a database without going through the pain of installing a deb from third party repository, which might not work or not be compatible with your system anymore ?

Need to install different versions of a database side by side on local system ?

Don't want to waste your time writing configuration to get started ?

Don't want to deploy and configure complex kubernetes charts ?

devenv was made just for that

All you need is ubuntu, bash and docker engine

Each package is installed as a docker container with a data and config volumes and necessary ports are exposed to the host system

A package is missing ? Feel free to contribute, it's only few lines of bash

HF


# install

```
cd ~
git clone https://github.com/dchapkine/devenv.git
cd devenv/src
chmod +x ./devenv.sh
./devenv selfinstall
```

# usage

```

USAGE devenv
===
devenv install PACKAGE_NAME|all # installs package
devenv start PACKAGE_NAME|all # starts package service
devenv stop PACKAGE_NAME|all # stops package service
devenv selfupdate # pulls latest version of this script from git
./devenv selfinstall # adds script path to session PATH (you need to source ~/.bashrc after that)

PACKAGES:
===
+ mongodb5 is running
  connect to mongodb5 using localhost:55001
  connect to mongodb cli using docker exec -it mongodb5 mongo
+ mysql8 is running
  connect to mysql8 using localhost:55002
  connect to mysql8 cli using docker exec -it mysql8 mysql -uroot -proot
+ redis7 is running
  connect to redis7 using localhost:55003
  connect to redis7 cli using docker exec -it redis7 redis-cli -h 127.0.0.1
+ neo4j4ce is running
  connect to neo4j4ce using localhost:55004 for http and localhost:55004 for bolt
  connect to neo4j4ce cli using docker exec -it neo4j4ce cypher-shell -u neo4j -p admin
  access neo4j browser here: http://localhost:55004

```

# compatibility

Works exclusively on ubuntu and bash + docker engine, not tested on anything else


# troubleshooting

If you get this error trying to run devenv...

```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
```

... you should make sure your user can run docker without sudo

follow instructions in this topic:

https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket




