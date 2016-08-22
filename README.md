# Mockend

Really really (really?) tiny backend that mocks JSON responses !

Developing application that needs third-party servers to work properly is very painful (configuration, need to be online, server down, backend feature not implemented yet, ...). Here is a very straightforward solution to fake all that servers and make them answer what you want.

All you need is **Docker** and the **JSON file** the server needs to response.

## Run

```
docker run -d -p 80 -v /stuff/data.json:/data.json virtualpusher/mockend
```

## JSON

The JSON file may directly contain the response that need to be served:

```
{
    "spoil": "on",
    "braceyourself": true
}
```

Or, it may also describe the responses by endpoints:

```
{
    "/": {
        "name": "GOT"
    },
    "/daenerys": {
        "name": "Targaryen",
        "fire_resistance": true,
        "lives": 1
    },
    "/jon": {
        "name": "Snow",
        "ice_resistance": true,
        "lives": 2
    }
}
```

## Build your own mockend

Create a new **Dockerfile** and start from `virtualpusher/mockend` base image:

```
FROM virtualpusher/mockend
COPY got.json /data.json
```

> Use `COPY` instruction to add your custom json data file under `/data.json`:

To finish, build and run:

```
docker build -t mockend-got .
docker run -d -p 80 mockend-got
```

Now you are free from any third-party servers. Go work offline !

Enjoy!

