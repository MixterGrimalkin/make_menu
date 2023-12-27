require File.expand_path('lib/make_menu/version', __dir__)

Gem::Specification.new do |s|
  s.name = "make_menu"
  s.version = MakeMenu::VERSION
  s.summary = "Generates an interactive menu from a Makefile"
  s.authors = ["Barri Mason"]
  s.email = "loki@amarantha.net"
  s.files = Dir[
    'lib/**/*.rb',
    'make_menu.gemspec',
    'Gemfile',
    'Gemfile.lock'
  ]
  s.homepage =
    "https://rubygems.org/gems/make_menu"
  s.license = "MIT"
  s.add_dependency 'tty-screen', '~> 0.8.2'
  s.description = %(
Creates a number-selection menu from a Makefile. The menu will attempt to fill the width of the terminal window.

- Any targets in the Makefile with a double-hash comment will be displayed, e.g.:
    serve: ## Start Rails server in background
  This will display a line such as '1. Start Rails server in background' which runs the command `make serve`.

- A line that starts with a triple-hash will create a new menu group, e.g.:
    ### Docker Commands
  This will begin a new group with the header 'Docker Commands'

- The environment variable MENU can be used to specify a custom menu class, e.g.:
    export MENU=Accounts
  This assumes that a class `AccountsMenu` is defined in the file `accounts_menu.rb`

  You can define two constants in your custom class:
    LOGO (String) text or ASCII art to display above the menu
    HIGHLIGHTS (Hash{String=>[Symbol,Array<Symbol>]}) Add coloring to specific words or phrases

- The environment variable MAKEFILE can specify a Makefile. The default is './Makefile'.

The menu will not display any targets called 'menu' or 'status'. The latter, if present, is called each
time the menu displays.

-----------------------------
Docker Container Status Panel
-----------------------------

Displays a color-coded panel indicating whether or not a Docker container is running.

You must define a custom class inheriting from `MakeMenu::StatusPanel` and indicate this using
the environment variable MENU, e.g.:
    export MENU=Accounts
This assumes that a class `AccountsStatusPanel` is defined in the file `accounts_status_panel.rb`

You can define a constant CONTAINERS {String=>String} in this custom class to map the displayed
label to the container name, e.g.:
    CONTAINERS = { 'Backend' => 'myapp-backend-1' }

)
end