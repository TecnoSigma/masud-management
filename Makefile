HOST_USER := $(shell id -u $$USER):$(shell id -g $$USER)
APP := seven_facilities
RUN := docker-compose run --user $(HOST_USER) $(APP)

run:
  @rm -f tmp/pids/server.pid
  docker-compose up
test:
  $(RUN) bundle exec rspec spec
console:
  $(RUN) bundle exec rails c
rubycritic:
  $(RUN) bundle exec rubycritic
rubocop:
  -$(RUN) bundle exec rubocop --cache false -A
bash:
  $(RUN) /bin/bash
clean:
  docker-compose down
  rm -fr ./vendor/bundle
  rm -rf .bundle
