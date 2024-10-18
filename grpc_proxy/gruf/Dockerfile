FROM ruby:3.3.5-slim

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get -y update && apt-get install -y build-essential

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

CMD ["ruby", "server.rb"]
