# frozen_string_literal: true

require_relative 'make_menu/console/color_string'
require_relative 'make_menu/menu'

require 'tty-screen'

module MakeMenu
  String.include MakeMenu::Console::ColorString

  trap('SIGINT') { throw StandardError }

  def self.run(makefile = './Makefile', &block)
    MakeMenu::Menu.new(makefile).run(&block)
  end
end
