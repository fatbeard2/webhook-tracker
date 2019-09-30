FROM elixir:1.9.1-slim

RUN apt-get update && apt-get install -y wget inotify-tools
RUN wget https://deb.nodesource.com/setup_10.x -O nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get -y install nodejs

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force hex phx_new 1.4.10

WORKDIR /wht
EXPOSE 4000
