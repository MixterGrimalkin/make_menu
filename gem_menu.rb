require_relative 'lib/make_menu/version'

class GemMenu < MakeMenu::Menu
  def display_header
    puts
    puts '  MakeMenu  '.bold.black.light_yellow_bg.align(:center)
    puts MakeMenu::VERSION.center(12).bold.light_yellow.black_bg.align(:center)
  end
end
