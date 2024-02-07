.SILENT:

menu:
	# This opens the menu, and as the first target it will be run when you just enter `make`
	ruby tools/menu.rb

plain_menu:
	# This is the standard way to run MakeMenu without customisation
	ruby -r make_menu -e MakeMenu.run

help:
	# This rather daunting Bash one-liner was the original inspiration for MakeMenu
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\033[0m\n", $$1, $$2}'

### Docker

up: ## Start servers
	# This simulates starting a server, by touching a file which is then read by a BADGE
	echo "Starting Docker containers...."
	touch .server_pid

down: ## Stop servers
	# This simulates stopping a server, by deleting the file
	echo "Stopping Docker containers...."
	rm -f .server_pid

### Firmware

port: ## Set serial port
	# This uses MakeMenu's `prompt` feature to edit the value in the file `.serial_port` which is then read by a FIELD
	ruby -r make_menu -e 'MakeMenu.prompt value_from_file: :serial_port' 'Enter serial port: '

install: ## Install firmware
	# This shows how to use the value from the file `.serial_port` (even if it doesn't exist)
	echo "Compiling...."
	sleep 0.2
	touch .serial_port
	echo "Uploading to `cat .serial_port`...."
	sleep 1.8
