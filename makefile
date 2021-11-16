ifneq (,$(wildcard ./.env))
	include .env
	export $(shell sed 's/=.*//' .env)
endif

#-----------------------------------------------------------
##@ # Init command
#-----------------------------------------------------------

up: ## Start the project stack
	@docker-compose up -d

up-force: ## Start the project stack with recreate step
	@docker-compose up -d --force-recreate

up-build: ## Start the project stack with recreate & build steps
	@docker-compose up -d --build --force-recreate

down: ## Stop the project stack
	@docker-compose down

restart: down up ### Restart the project stack

status: ## Stack status
	@docker-compose ps

#-----------------------------------------------------------
##@ # Database commands
#-----------------------------------------------------------

database:
	@docker-compose exec database psql
database-dev:
	@docker-compose exec database psql -d postgres
database-test:
	@docker-compose exec database psql -d Backend_test
database-logs:
	@docker-compose logs -f database

#-----------------------------------------------------------
##@ # Client commands
#-----------------------------------------------------------

backend: ## Opens a shell inside the Client container
	@docker-compose exec backend sh
backend-migrate:
	@docker-compose exec backend rake db:migrate
backend-spec: ## Opens a shell inside the Client container
	@docker-compose exec backend rspec spec/
backend-restart: ## Restart the Client service
	@docker-compose restart backend
backend-logs: ## Read Client service logs
	@docker-compose logs -f backend
