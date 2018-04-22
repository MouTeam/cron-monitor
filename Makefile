DOCKER_COMPOSE  = docker-compose

EXEC_PHP        = $(DOCKER_COMPOSE) exec -T php /entrypoint

SYMFONY         = $(EXEC_PHP) bin/console
COMPOSER        = $(EXEC_PHP) composer

##
## Cron Monitor Project
## -------
##

build:
	$(DOCKER_COMPOSE) pull --parallel --ignore-pull-failures
	$(DOCKER_COMPOSE) build --pull

kill:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

install: .env build start vendor                             ## Install and start the project

reset: kill install                                          ## Stop and start a fresh install of the project

start:                                                       ## Start the project
	$(DOCKER_COMPOSE) up -d --remove-orphans --no-recreate

stop:                                                        ## Stop the project
	$(DOCKER_COMPOSE) down

clean: kill                                                  ## Stop the project and remove generated files
	rm -rf .env vendor

.PHONY: build kill install reset start stop clean

##
## Utils
## -----
##

cc:                                                          ## Clear the cache in dev env
	$(SYMFONY) cache:clear --no-warmup
	$(SYMFONY) cache:warmup

.PHONY: cc

# rules based on files
composer.lock: composer.json
	$(COMPOSER) update --lock --no-scripts --no-interaction

vendor: composer.lock
	$(COMPOSER) install

.env: .env.dist
	@if [ -f .env ]; \
	then\
		echo '\033[1;41m/!\ The .env.dist file has changed. Please check your .env file (this message will not be displayed again).\033[0m';\
		touch .env;\
		exit 1;\
	else\
		echo cp .env.dist .env;\
		cp .env.dist .env;\
	fi

##
## Quality assurance
## -----------------
##

lint: ly                                                     ## Lints twig and yaml files

ly: vendor
	$(SYMFONY) lint:yaml config

.PHONY: lint ly

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help
