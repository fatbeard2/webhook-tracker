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

## Documentation

```
docker run --rm -v "$PWD":/wht webhook-tracker mix docs
> Docs successfully generated.
> View them at "doc/index.html".
```

## Observer debugging

```
# run in X11 console - https://github.com/c0b/docker-elixir/issues/77#issuecomment-408586728

docker run --rm -it -v "$PWD":/wht -p 4000:4000 -e DISPLAY=host.docker.internal:0 webhook-tracker iex -S mix phx.server
:observer.start()
```
