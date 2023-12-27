require_relative 'make_menu/color_string'
require_relative 'make_menu/menu'
require_relative 'make_menu/status_panel'

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
  rescue LoadError => _e
    puts "ERROR! Expected file ./#{menu_name.downcase}_menu.rb to define class #{menu_name.capitalize}Menu < MakeMenu::Menu"
  end

  def self.status
    if (menu_name = ENV.fetch('MENU', nil))
      require "./#{menu_name.downcase}_status_panel.rb"
      Object.const_get("#{menu_name.capitalize}StatusPanel").new.display
    else
      MakeMenu::StatusPanel.new.display
    end
  rescue LoadError => _e
    puts "ERROR! Expected file ./#{menu_name.downcase}_status_panel.rb to define class #{menu_name.capitalize}StatusPanel < MakeMenu::StatusPanel"
  end
end