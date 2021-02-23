### app builder ###
FROM hexpm/elixir:1.11.3-erlang-23.2.5-alpine-3.13.1 AS builder

RUN apk add --no-cache build-base nodejs npm

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get && \
    mix deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
COPY rel rel
RUN mix compile

RUN mix release

### final image ###
FROM alpine:3.13.1

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/toastme ./

RUN chmod +x ./entrypoint.sh

ENV HOME=/app

CMD ["./entrypoint.sh"]
