FROM ruby:2.7.2-alpine3.12

COPY Gemfile* /app/
WORKDIR /app

RUN gem install bundler && \
    bundle install -j4

COPY . /app
