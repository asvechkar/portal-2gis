FROM ruby:2.7.8

RUN apt-get update -qq && apt-get install -y g++ imagemagick nodejs postgresql-client
RUN mkdir /opt/app

WORKDIR /opt/app

COPY Gemfile /opt/app/Gemfile

RUN bundle install --jobs 20 --retry 5

COPY . /opt/app

COPY ./docker/local/entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
