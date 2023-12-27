require_relative 'make_menu/color_string'
require_relative 'make_menu/menu'

require 'tty-screen'

module MakeMenu
  String.include MakeMenu::ColorString

  def self.run
    # Allows CTRL+C to return to the menu instead of exiting the script
    trap('SIGINT') { throw StandardError }

    makefile = ENV.fetch('MAKEFILE', './Makefile')

    if (menu_name = ENV.fetch('MENU', nil))
      require "./#{menu_name.downcase}_menu.rb"
      Object.const_get("#{menu_name.capitalize}Menu").new(makefile).run
    else
      MakeMenu::Menu.new(makefile).run
    end

  rescue LoadError, NameError => _e
    puts
    puts 'No customisation class found!'.red.bold
    puts
    puts 'Expected file:'
    puts "    ./#{menu_name.downcase}_menu.rb".cyan
    puts
    puts 'To define class:'
    puts "    #{menu_name.capitalize}Menu < MakeMenu::Menu".yellow
    puts
    exit 1
  end
end