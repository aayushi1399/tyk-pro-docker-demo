# Getting started with Active-Active 

Create .env file

`cp .env.example .env`

Run the following commands to start DBs, Pump, and Control Plane A

```
docker-compose -f docker-compose.dbs.yml up tyk-redis-cluster-region-a-master-0 tyk-redis-cluster-region-a-master-1 tyk-redis-cluster-region-b-master-2 tyk-redis-cluster-region-b-master-3 tyk-redis-cluster-region-a-replica-0 tyk-redis-cluster-region-a-replica-1 tyk-redis-cluster-region-b-replica-2 tyk-redis-cluster-region-b-replica-3 tyk-postgres tyk-pump
docker-compose -f docker-compose.cp.a.yml up tyk-dashboard-region-a tyk-gateway-region-a tyk-mdcb-region-a
```

Navigate to `http://localhost:3000` to bootstrap your dashboard. 

Run the following commands to enable hybrid on your org. 

```
export DASH_ADMIN_SECRET=12345
export DASH_URL=http://localhost:3000
export ORG_ID=
curl $DASH_URL/admin/organisations/$ORG_ID -H "Admin-Auth: $DASH_ADMIN_SECRET" | python3 -mjson.tool > myorg.json
```

Replace the following section in the `myorg.json`

```
  "hybrid_enabled": false,
  "event_options": {},
```

With

```
  "hybrid_enabled": true,
  "event_options": {
    "key_event": {
      "email": "test@test.com"
    },
    "hashed_key_event": {
      "email": "test@test.com"
    }
  },
```

Finally push the modified org object.

`curl -X PUT $DASH_URL/admin/organisations/$ORG_ID -H "Admin-Auth: $DASH_ADMIN_SECRET" -d @myorg.json`

Modify .env and add the `TYK_GW_SLAVEOPTIONS_RPCKEY` and `TYK_GW_SLAVEOPTIONS_APIKEY` values.

Finally, run the following commands to start up your Hybrid A Gateway, Control Plane B, and Hybrid B Gateway

```
docker-compose -f docker-compose.hybrid.a.yml up tyk-redis-region-a-hybrid-0 tyk-gateway-region-a-hybrid-0
docker-compose -f docker-compose.cp.b.yml up tyk-dashboard-region-b tyk-gateway-region-b tyk-mdcb-region-b
docker-compose -f docker-compose.hybrid.b.yml up tyk-redis-region-b-hybrid-0 tyk-redis-region-b-hybrid-1 tyk-gateway-region-b-hybrid-0 tyk-gateway-region-b-hybrid-1
```
