# Servers System

To setup an infrastructure for dev environment run the following command:
```shell
./start.sh -g dev
```

To destroy an infrastructure for test environment run the fllowing command:
```shell
./start.sh -g test
```

To setup an infrastructure for production environment run the fllowing command:
```shell
./start.sh -g prod
```

To destroy an infrastructure for any environment run the following command:
```shell
docker-compose down -v
```