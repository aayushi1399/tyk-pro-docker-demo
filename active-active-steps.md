# Getting started with Active-Active 

Run the following commands to start DBs, Pump, and Control Plane A

```
docker-compose -f docker-compose.dbs.yml up
docker-compose -f docker-compose.cp.a.yml up
```

Navigate to `http://localhost:3000` to bootstrap your dashboard. 

Run the following commands to enable hybrid on your org. 

```
export DASH_ADMIN_SECRET=12345
export DASH_URL=http://localhost:3000
export ORG_ID=6269575080d0700001f32cf6
curl $DASH_URL/admin/organisations/$ORG_ID -H "Admin-Auth: $DASH_ADMIN_SECRET" | python3 -mjson.tool > myorg.json
```

Replace the following section in the `myorg.json`

``
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
````

Finally push the modified org object.

`curl -X PUT $DASH_URL/admin/organisations/$ORG_ID -H "Admin-Auth: $DASH_ADMIN_SECRET" -d @myorg.json`

# Modify .env and add the `TYK_GW_SLAVEOPTIONS_RPCKEY` and `TYK_GW_SLAVEOPTIONS_APIKEY` values.

Finally, run the following commands to start up your Hybrid A Gateway, Control Plane B, and Hybrid B Gateway

```
docker-compose -f docker-compose.hybrid.a.yml up
docker-compose -f docker-compose.cp.b.yml up
docker-compose -f docker-compose.hybrid.b.yml up
```
