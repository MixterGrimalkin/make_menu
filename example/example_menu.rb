class ExampleMenu < MakeMenu::Menu
  # The constant LOGO [String] is printed at the top of the menu
  LOGO = "
  ___  _ _ _____ _        _____ _     _.................
 / _ \\| | |_   _| |      |_   _| |   (_)................
/ /_\\ \\ | | | | | |__   ___| | | |__  _ _ __   __ _ ___.
|  _  | | | | | | '_ \\ / _ \\ | | '_ \\| | '_ \\ / _` / __|
| | | | | | | | | | | |  __/ | | | | | | | | | (_| \\__ \\
\\_| |_/_|_| \\_/ |_| |_|\\___\\_/ |_| |_|_|_| |_|\\__, |___/
                                               __/ |....
                                              |___/.....
".gsub('.', ' ').light_magenta.bold # The gsub here is to ensure the logo centers properly on screen

  # The constant HIGHLIGHTS is used to change the color of specific words or phrases within the menu text.
  # Each value may be a symbol or an array of symbols
  HIGHLIGHTS = {
    'Start' => :green,
    'Stop' => %i[red bold]
  }

  # Override this method to change the color of the group titles (symbol or array of symbols)
  protected def group_title_color
    %i[light_magenta bold]
  end
end