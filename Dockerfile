FROM elixir:1.7
MAINTAINER Gorka López de Torre <gorka@gorka.io>
RUN apt-get update && apt-get install --yes postgresql-client
ADD . /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force hex phx_new 1.4.0
WORKDIR /app
EXPOSE 4000
CMD ["./run.sh"]