# File: my_app/Dockerfile
FROM elixir:alpine as build

RUN apk add --update git && \
    rm -rf /var/cache/apk/*


RUN apk add --update nodejs \
    npm


# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

RUN mkdir /app
WORKDIR /app

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN mix release --overwrite

# prepare release image
FROM alpine AS app

# install runtime dependencies
 RUN apk add --update openssl ncurses-libs postgresql-client && \
    rm -rf /var/cache/apk/*


EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/petal .
RUN chown -R nobody: /app
USER nobody


COPY entrypoint.sh .

ENV HOME=/app
CMD ["/app/entrypoint.sh"]