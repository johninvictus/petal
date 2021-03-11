FROM bitwalker/alpine-elixir-phoenix:latest AS build

# install build dependencies
# RUN apk add --no-cache build-base npm git python

RUN mix local.hex --force \
  && mix archive.install --force hex phx_new 1.5.8


RUN curl -sL https://deb.nodesource.com/setup_14.x \
    && apk add --update nodejs 

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm rebuild node-sass
RUN npm i 
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

# install runtime dependencies
RUN apk add --update openssl ncurses-libs postgresql-client && \
    rm -rf /var/cache/apk/*


WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/petal ./

COPY entrypoint.sh .

ENV HOME=/app

CMD ["/app/entrypoint.sh"]]