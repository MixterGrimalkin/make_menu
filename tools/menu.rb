# frozen_string_literal: true

require_relative '../lib/make_menu'

OPTIONS = {
  group_title_color: %i[yellow bold],
  clear_screen: true,
  pause_on_success: true
}

HIGHLIGHTS = {
  'Build and Install' => %i[bold light_yellow]
}

MakeMenu.run do |menu|
  menu.options { OPTIONS }
  menu.highlights { HIGHLIGHTS }
  menu.header do
    puts
    puts '  MakeMenu  '.bold.black.light_yellow_bg.align(:center)
    puts `bump current`.strip.center(12).bold.light_yellow.black_bg.align(:center)
    puts
  end
end
