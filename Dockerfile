FROM ruby:4.0.6

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential curl git libpq-dev libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]