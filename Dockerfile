FROM ruby:3.3

RUN apt-get update && apt-get install -y libnghttp2-dev
