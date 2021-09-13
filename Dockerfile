FROM ruby:2.6.6

RUN apt install curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && \
  apt-get install -y nodejs && \
  apt-get install -y build-essential && \
  apt-get install -y libpq-dev && \
  apt-get install -qq -y --no-install-recommends cron && \
  rm -rf /var/lib/apt/lists/*
RUN apt-get install -y npm
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y graphviz
RUN npm install --global yarn

COPY ~/.yarnrc ~/.yarnrc
RUN mkdir /seven_facilities
WORKDIR /seven_facilities
COPY Gemfile /seven_facilities/Gemfile
COPY Gemfile.lock /seven_facilities/Gemfile.lock
RUN bundle install
COPY . /seven_facilities
RUN bundle exec rails webpacker:install
RUN yarn install --check-files

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
