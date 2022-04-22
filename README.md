# Tyk Pro Demo using Docker

This compose file is designed to provide a quick, simple demo of the Tyk stack, this includes Tyk Gateway, Tyk Dashboard, Tyk Portal, Mongo, & Redis.

This repo great for proof of concept and demo purpose, but if you want test performance, you need to move each component to separate machine, following our documentation https://tyk.io/docs/.

## Step 1: Add your dashboard license

Open the `tyk_analytics.env` file in the `confs/` folder and add your license string to the first line.

## Step 2: Initialise the Docker containers

Run docker compose:

With a `Mongo` database:
```
$ docker-compose up
```

With a `PostgreSQL` database:
```
$ docker-compose -f ./docker-compose.yml -f ./docker-compose.postgres.yml up
```

Please note that this command may take a while to complete, as Docker needs to download and provision all of the containers.

This will run in non-daemonised mode so you can see all the output.

## Step 3: Bootstrap the Tyk installation

Bootstrap the instance:

Open your browser to http://localhost:3000.  You will be presented with the Bootstrap UI to create your first organisation and admin user.

## Tear down

To delete all containers as well as remove all volumes from your host:

Mongo:
```
$ docker-compose down -v
```

PostgreSQL:
```
$ docker-compose -f ./docker-compose.yml -f ./docker-compose.postgres.yml down -v
```

## Python Starter

1. Modify the plugin if you want: `middleware.py`

2. zip the contents of the folder to the folder:
```
$ zip -r bundle_v1.zip manifest.json middleware.py
```

This creates a bundle file called "bundle_v1.zip".  This allows the Gateway to download it from a server.


3. Import `apidefinitionexample.json` or Create an API and add this to the RAW API Definition:
```
"custom_middleware_bundle": "bundle_v1.zip",
```

Your Gateway will now download `bundle_v1.zip` bundle now from the bundle HTTP server


4. Curl to test:

``` 
$ curl localhost:8080/httpbin/get
{
  "args": {}, 
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip", 
    "Cache-Control": "max-age=259200", 
    "Host": "httpbin.org", 
    "If-Modified-Since": "Fri, 22 Apr 2022 15:31:30 GMT", 
    "Testheader": "testvalue", 
    "User-Agent": "curl/7.77.0", 
    "X-Amzn-Trace-Id": "Root=1-6262d0e5-05a874fb7737630c7d0bf5bd"
  }, 
  "origin": "172.25.0.1, 172.19.131.107, 10.82.56.107, 199.167.24.148", 
  "url": "http://httpbin.org/get"
}

```

Our header has been injected by the plugin.


5. Before you make another update, you must increment or change the name of `bundle_xyz.zip` so that the Gateway won't use the plugin in the local cache.