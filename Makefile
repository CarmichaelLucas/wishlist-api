# Configurações de comandos basicos

# make build
build: clean
	@docker-compose build
	@docker-compose up -d
	@docker-compose run api rails db:drop db:create db:migrate

# make remove
remove: down
	@docker image rmi lucas/api

# make bash
bash:
	@docker-compose exec api bash

# make down
down:
	@docker-compose down

# make clean
clean:
	@sudo rm -rf tmp/*
	@mkdir -p tmp/pids && touch tmp/pids/.keep

# make logs
logs:
	@docker-compose logs -f api

# make permit
permit:
	@sudo chown -R ${USER}:${USER} .