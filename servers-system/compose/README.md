# Servers System

 **Commands has to be run in compose direcotry!**

Before running any docker compose command you should always check configuration using the following command:
```shell
docker-compose --env-file ../config/.env.dev config
```

To setup an infrastructure for dev environment run the following command:
```shell
docker-compose --env-file ../config/.env.dev up --build
```

To setup an infrastructure for test environment run the fllowing command:
```shell
docker-compose --env-file config/.env.test -f docker-compose.yml -f docker-compose.test.yml up --build
```

To destroy an infrastructure for test environment run the fllowing command:
```shell
docker-compose --env-file config/.env.test -f docker-compose.yml -f docker-compose.test.yml up --build
```

To setup an infrastructure for production environment run the fllowing command:
```shell
docker-compose --env-file config/.env.prod -f docker-compose.yml -f docker-compose.prod.yml up --build
```

To destroy an infrastructure for any environment run the following command:
```shell
docker-compose down -v
```