FROM ruby:3.4.7-slim

# Instala dependencias del sistema necesarias
RUN apt-get update -qq && apt-get install -yq \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  curl \
  git \
  libyaml-dev \
  --no-install-recommends && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instala Bundler (si no lo hiciste con un paso anterior, déjalo)
RUN gem install bundler
COPY Gemfile Gemfile.lock ./
RUN bundle install
