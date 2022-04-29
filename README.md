# Getting started with Active-Active 

Run `cp .env.example .env` to create `.env` file. Add your MDCB and Dahsboard licenses to the `.env` file.

Run the following commands to start DBs, Pump, and Control Pane A

```
docker-compose -f dbs/docker-compose.yml up
docker-compose -f region-a-control-plane/docker-compose.yml --env-file .env up
```

Run `bash scripts/bootstrap.sh` to bootstrap your dashboard instant.

Finally, run the following commands to start up your Hybrid A Gateway, Control Plane B, and Hybrid B Gateway

```
docker-compose -f region-a-edges/docker-compose.yml --env-file .env up
docker-compose -f region-b-control-plane/docker-compose.yml --env-file .env up
docker-compose -f region-b-edges/docker-compose.yml --env-file .env up
```

Now you should be able to access the dashboard at [http://localhost:3000](http://localhost:3000) user credintials:

Username: user@exmaple.com
Password: topsecretpassword