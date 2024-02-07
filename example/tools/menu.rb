# frozen_string_literal: true

require 'make_menu'

# This is an example menu demonstrating the basic features of MakeMenu.

# ASCII art to display above the menu...
LOGO = '
!  _____         ___________.__    .__.!!!!!!!!!!!!!!!!!!!!!
  /     \ ___.__.\__    ___/|  |__ |__| ____    ____  ______
 /  \ /  <   |  |  |    |   |  |  \|  |/    \  / ___\/  ___/
/    Y    \___  |  |    |   |   Y  \  |   |  \/ /_/  >___ \!
\____|__  / ____|  |____|   |___|  /__|___|  /\___  /____  >
        \/\/                     \/        \//_____/     \/!
'.strip.gsub('!', ' ').light_magenta.bold.highlight('_', :light_red, :red)
# This (^^^) train-wreck method chain makes it look pretty.

# Some general options for the menu's appearance...
OPTIONS = {
  group_title_color: %i[red bold],
  badges_first: false
}

# Specific words or phrases in the menu text can be highlighted...
HIGHLIGHTS = {
  'Start' => :green,
  'Stop' => :red,
  'Install firmware' => :bold
}

# This block is run when the menu is opened...
MakeMenu.run do |menu|
  # These are defined as constants outside the block to keep certain linters happy...
  menu.options { OPTIONS }
  menu.highlights { HIGHLIGHTS }

  # This block is run each time the menu re-draws...
  menu.header do
    puts
    puts LOGO.align_block(:center)
    puts
  end

  # FIELDS are displayed in an aligned vertical stack above the menu.
  # They can be labelled or un-labelled.

  # A labelled field that reads its value from the file `.serial_port` in the current directory...
  menu.add_field 'Serial Port '.black_bg.bold, # Optional label, with coloring
                 value_from_file: :serial_port, # Passing a Symbol assumes a hidden file (i.e. starting with `.`)
                 color: %i[magenta bold] # Color for the value

  # A labelled field that generates a random number each time the menu re-draws...
  menu.add_field 'Lucky Number '.black_bg.bold do
    rand(10).to_s.cyan
  end

  # BADGES are displayed in a wrapped horizontal row above the menu.
  # They can be labelled or un-labelled.

  # An un-labelled badge which randomly switches colors on each re-draw
  menu.add_badge do
    if rand(10) > 5
      '    MaKeMeNu   '.black_bg.light_yellow.bold
    else
      '    MaKeMeNu   '.light_yellow_bg.black.bold
    end
  end

  # A labelled badge which changes according to the presence of the file `.server_pid` on each re-draw
  menu.add_badge 'Local: '.black_bg.bold do
    if File.exists?('.server_pid')
      ' ON-LINE '.green_bg.bold
    else
      ' OFFLINE '.red_bg.dark.bold
    end
  end
end
