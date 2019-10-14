test:
	bundle exec rspec spec

setup:
	cp -n .env.example .env || true
	bin/setup
	bin/rails db:fixtures:load

fixtures-load:
	bin/rails db:fixtures:load

clean:
	bin/rails db:drop

db-reset:
	bin/rails db:drop
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:fixtures:load

start:
	bundle exec rails s

lint:
	bundle exec rubocop

linter-fix:
	bundle exec rubocop --auto-correct

deploy:
	cap production deploy

.PHONY: test
