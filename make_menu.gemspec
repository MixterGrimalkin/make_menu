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
    "https://github.com/MisterGrimalkin/make_menu"
  s.license = "MIT"
  s.add_dependency 'tty-screen', '~> 0.8.2'
  s.description = ""
end