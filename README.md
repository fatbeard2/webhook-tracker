### Webhook tracker

## Installation

```
docker build -t webhook-tracker .
docker run --rm -v "$PWD":/wht webhook-tracker ./install-deps.sh
```

## Spin up web-server

```
docker run --rm -it -v "$PWD":/wht -p 4000:4000 webhook-tracker mix phx.server
```

## Bash session

```
docker run --rm -it -v "$PWD":/wht webhook-tracker bash
```
