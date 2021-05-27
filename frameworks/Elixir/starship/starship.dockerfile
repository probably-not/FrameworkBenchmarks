FROM elixir:1.12.0-alpine AS builder
RUN apk update && apk --no-cache --update add build-base

WORKDIR /starship

RUN mix local.hex --force && \
  mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
# COPY config config
RUN mix do deps.get, deps.compile
COPY lib lib
# COPY rel rel

RUN mix do compile, release

FROM alpine:3.13.5 AS runtime
RUN apk update && apk --no-cache --update add openssl ncurses-libs
RUN apk --no-cache --update add libgcc libstdc++

WORKDIR /starship

RUN chown nobody:nobody /starship
USER nobody:nobody
COPY --from=builder --chown=nobody:nobody /starship/_build/prod/rel/starship ./
ENV HOME=/starship
ENV LANG=C.UTF-8

EXPOSE 8080

CMD ["bin/starship", "start"]