.SILENT:

menu:
	ruby tools/menu.rb

### Local

build: ## Build Gem
	gem build

install: ## Install locally
	gem install `ls -1t *.gem | head -n 1`

build_install: build install ## Build and Install

uninstall: ## Uninstall locally
	gem uninstall make_menu

clear: ## Clear old gems
	tools/clear_gems.sh

### RubyGems

publish: ## Publish Gem
	gem push `ls -1t *.gem | head -n 1`
