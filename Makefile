DOCKER_COMPOSE  = docker-compose

EXEC_PHP        = $(DOCKER_COMPOSE) exec -T php /entrypoint
EXEC_JS         = $(DOCKER_COMPOSE) exec -T node /entrypoint

SYMFONY         = $(EXEC_PHP) bin/console
COMPOSER        = $(EXEC_PHP) composer
NPM            = $(EXEC_JS) npm

##
## Cron Monitor Project
## -------
##

build:
	$(DOCKER_COMPOSE) pull --parallel --ignore-pull-failures
	$(DOCKER_COMPOSE) build --pull

kill:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

install: .env build start db assets                          ## Install and start the project

reset: kill install                                          ## Stop and start a fresh install of the project

start:                                                       ## Start the project
	$(DOCKER_COMPOSE) up -d --remove-orphans --no-recreate

stop:                                                        ## Stop the project
	$(DOCKER_COMPOSE) down

clean: kill                                                  ## Stop the project and remove generated files
	rm -rf .env vendor node_modules

.PHONY: build kill install reset start stop clean

##
## Utils
## -----
##

db: .env vendor                                              ## Reset the database and load fixtures
	$(SYMFONY) doctrine:database:drop --if-exists --force
	$(SYMFONY) doctrine:database:create --if-not-exists
	$(SYMFONY) doctrine:migrations:migrate --no-interaction --allow-no-migration
	$(SYMFONY) doctrine:fixtures:load --no-interaction --purge-with-truncate

assets: node_modules                                         ## Run Webpack Encore to compile assets
	$(NPM) run dev

watch: node_modules                                          ## Run Webpack Encore in watch mode
	$(NPM) run watch

cc:                                                          ## Clear the cache in dev env
	$(SYMFONY) cache:clear --no-warmup
	$(SYMFONY) cache:warmup

.PHONY: db assets watch cc

# rules based on files
composer.lock: composer.json
	$(COMPOSER) update --lock --no-scripts --no-interaction

vendor: composer.lock
	$(COMPOSER) install

node_modules: package-lock.json
	$(NPM) install
	@touch -c node_modules

package-lock.json: package.json
	$(NPM) update

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

php-cs-fixer:                                                ## php-cs-fixer (http://cs.sensiolabs.org)
	$(EXEC_PHP) ./vendor/bin/php-cs-fixer fix --verbose --diff

.PHONY: lint ly php-cs-fixer

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help
