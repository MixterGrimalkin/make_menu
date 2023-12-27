.SILENT:

menu:
	MENU=Gem ruby -r ./lib/make_menu -e MakeMenu.run

### Gem

build: ## Build Gem
	gem build

install: ## Install locally
	gem install `ls -1t *.gem | head -n 1`

build_install: build install ## Build and install

publish: ## Publish to RubyGems
	gem push `ls -1t *.gem | head -n 1`
