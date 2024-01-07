# frozen_string_literal: true

require_relative '../lib/make_menu'

MakeMenu.run do |menu|
  menu.options do
    {
      group_title_color: %i[yellow bold],
      clear_screen: true,
      pause_on_success: true
    }
  end

  menu.highlights do
    {
      'Build and Install' => %i[bold light_yellow]
    }
  end

  menu.header do
    puts
    puts '  MakeMenu  '.bold.black.light_yellow_bg.align(:center)
    puts `bump current`.center(12).bold.light_yellow.black_bg.align(:center)
    puts
  end
end
