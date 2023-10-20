build: db

db: main.c
	gcc main.c -o db

test: build spec/database_spec.rb
	bundle exec rspec
