FROM ruby:3.0-alpine

RUN apk update && apk add build-base libpq postgresql-dev git file py-pip shared-mime-info

RUN pip install yamllint

RUN mkdir /app

WORKDIR /app

COPY . .

RUN bundle install

