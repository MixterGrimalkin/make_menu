.SILENT:

menu:
	MENU=Example ruby -r make_menu -e MakeMenu.run

### Rails Server

go: ## Start server
	rails s > /dev/null &

stop: ## Stop server
	kill `cat tmp/pids/server.pid`

### Database

migrate: ## Migrate database
	rake db:migrate
	rake db:test:prepare

console:
	rails c
