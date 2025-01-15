# Setup for Local Postgres DB & Kestra
I was running into issues for the [DE Zoomcamp 2.2.3](https://www.youtube.com/watch?v=OkfLX28Ecjg) videos related to loading data into a target Postgres DB. I have mostly fixed these issues by creating a docker network that links the containers created in the first module's `docker-compose.yml` file, with those created in the second modules `docker-compose.yml` file. 

First, create the shared network: `docker network create shared-network`, where "shared-network" is the name of the network that will link everything together. Next, update both `docker-compose.yml` files to add the following properties:

```
# docker-compose-1.yml
networks:
  shared-network:
    external: true

services:
  service1:
    networks:
      - shared-network
```

```
# docker-compose-2.yml
networks:
  shared-network:
    external: true

services:
  service2:
    networks:
      - shared-network
```

Finally, you'll need to update the `values > url, username, and password` for the Postgres plugin at the bottom of your kestra flow file:
```
pluginDefaults:
  - type: io.kestra.plugin.jdbc.postgresql
    values:
      url: jdbc:postgresql://pgdatabase:5432/ny_taxi
      username: root
      password: root
```

I'm still running into some loading errors, but the staging and final tables were able to create, and I was able to inspect them in the DB I created in the first module. 
