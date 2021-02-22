# docker-webcdr

Build and running webcdr in Docker


## build image

`docker build -t pedrorobsonleao/webcdr .`

## run image

```bash
docker run \
   --name webcdr \
   --publish 9030:9030 \
   --env TZ=America/Sao_Paulo \
   --env DB_CLIENT=mysql \
   --env DB_CONNECTION_HOST=db \
   --env DB_CONNECTION_USER=cdrdb \
   --env DB_CONNECTION_PASSWORD=cdrpwd \
   --env DB_CONNECTION_DATABASE=asteriskcdrdb \
   --env DB_CONNECTION_CHARSET=utf8 \
   --env DB_INIT=TRU \
   --env CDR_TABLE=cdr \
   --env SESSION_KEY=123hjhfds7&&&kjfh&&&788 \
   --env AUTH_AD_DOMAIN=exemple \
   --env AUTH_AD_CONNECTION_URL=ldap://server.ip.address \
   --env AUTH_AD_CONNECTION_BASEDN=dc=example,dc=org \
   --env AUTH_AD_CONNECTION_USERNAME=cdruser@example.org \
   --env AUTH_AD_CONNECTION_PASSWORD=cdruser_ad_password \
   --detach \
   pedrorobsonleao/webcr
```

## docker-compose

This version up all insfrastructure with [mysql:5](https://hub.docker.com/_/mysql) amd [node:8-alpine](https://hub.docker.com/_/node/).

`docker-compose up --detach`

## how to use

http://localhost:9030

|user|passwort|
|-|-|
|admin|admincdr|

## references

* [ipoddubny/webcdr](https://github.com/ipoddubny/webcdr)
* [mifistor/docker-webcdr](https://github.com/mifistor/docker-webcdr)
