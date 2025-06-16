FROM ruby:3.1.2

# Force rebuild to install postgresql-client
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:migrate && rails s -b 0.0.0.0"]
