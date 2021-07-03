FROM debian:10

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    git \
    gnupg \
    wget \
  && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    postgresql-client-13 \
  && rm -rf /var/lib/apt/lists/*

RUN wget --quiet -O - "https://deb.nodesource.com/setup_14.x" | bash - \
  && apt-get install -y --no-install-recommends \
    nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g npm@latest

COPY ./server/package* /cache/server/
RUN cd /cache/server && npm ci

COPY ./client/package* /cache/client/
RUN cd /cache/client && npm ci

WORKDIR /home/src
