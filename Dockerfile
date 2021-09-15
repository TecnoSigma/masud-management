FROM ruby:2.6.3
RUN apt install curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs && apt-get install -y build-essential && apt-get install -y libpq-dev
RUN apt-get install -y npm
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install graphviz -y
RUN mkdir /seven_facilities
WORKDIR /seven_facilities
COPY Gemfile /seven_facilities/Gemfile
COPY Gemfile.lock /seven_facilities/Gemfile.lock
RUN bundle install
COPY . /seven_facilities

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
