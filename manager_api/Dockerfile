FROM elixir:latest

RUN apt-get update && \
    apt-get install -y postgresql-client && apt-get install -y inotify-tools && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

WORKDIR /app

COPY . /app

RUN mix local.hex --force

RUN mix local.rebar --force

RUN npm install

RUN mix do deps.get, deps.compile

COPY mix.exs .
COPY mix.lock .

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]




