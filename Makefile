HOST_USER := $(shell id -u $$USER):$(shell id -g $$USER)
APP := web
RUN := docker-compose run --user $(HOST_USER) $(APP)

build:
	docker-compose stop
	docker-compose build
run:
	rm -f tmp/pids/server.pid
	docker-compose up
tests:
	$(RUN) bundle exec rspec spec -fd
console:
	$(RUN) bundle exec rails c
rubycritic:
	$(RUN) bundle exec rubycritic
rubocop:
	$(RUN) bundle exec rubocop --cache false -A
bash:
	$(RUN) /bin/bash
clean:
	docker-compose down
	rm -fr ./vendor/bundle
	rm -rf .bundle

restart-database:
	$(RUN) bundle exec rake db:drop
	$(RUN) bundle exec rake db:create
	$(RUN) bundle exec rake db:migrate
	$(RUN) bundle exec rake db:seed
