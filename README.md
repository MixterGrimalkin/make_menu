# MakeMenu

A Ruby gem to automatically create a number-selection text menu from an annotated Makefile.

## Installation

To install this gem locally, run the following command:

```ruby
gem install make_menu
```

Or add this to your Gemfile:

```ruby
gem 'make_menu', '~> 2.1.0'
```

And run `bundle install`.

## The Makefile

MakeMenu builds a menu from annotations in the Makefile:

```makefile
# ~/code/all_the_things/Makefile

.SILENT:

prepare:
    chmod +x ./*.sh

### Start Things

thing: prepare ## Do something
	tools/do_the_thing.sh

otherthing: prepare ## Do something else 
	tools/do_another_thing.sh

### Stop Things

nothing: ## Kill all the things
	kill `ps aux | greo '_thing' | grep -v | awk '{ print $2 }'`
```

## Opening the Menu

Run the command:

```bash
ruby -r make_menu -e MakeMenu.run
```

And you'll get:

```text

           ALL_THE_THINGS  

    Start Things                 
       1.  Do something          
       2.  Do something else     
                                 
    Stop Things                  
       3.  Kill all the things   
                                 

         Press ESC to quit

          Select option: 

```

Type `1` and press ENTER to run the command `make thing`. When the command is complete
the menu will redraw. Press ESCAPE to quit the menu.

The menu is centred on screen and the groups will arrange themselves to take advantage of the terminal width.
If you change the size of your terminal window simply press ENTER to redraw the menu.

## Prompter

MakeMenu has a simple prompting tool which you can access directly. As an example, this command will display
the message "What is your favourite colour?" and allow the user to type a response. The response is returned on
standard error, so can be saved into a shell variable while still allowing the terminal to be used for user
interaction.

```bash
export fav_colour=$(ruby -r make_menu -e 'MakeMenu.prompt "What is your favourite colour? "' 2>&1 >/dev/tty)
```

You can also have the value loaded and saved to a file in the current directory.

If you want to save the value to a file and have that value appear for editing next time, do this:

```bash
ruby -r make_menu -e 'MakeMenu.prompt "What is your favourite colour?", value_from_file: :fav_colour'
```

Using a Symbol for `value_from_file` will assume a hidden file (ie. starting with `.`) so the above line
will use the file `.fav_colour`.

You can pass additional text as the first argument. This is printed above the prompt. If you omit the prompt, the
last line of the first argument will be used instead. So the above could be written:

```bash
ruby -r make_menu -e 'MakeMenu.prompt value_from_file: :fav_colour' 'What is your favourite colour?'
```

## Customisation

You can pass a block to the `run` method to customise the appearance of the menu:

```ruby
# ~/code/all_the_things/menu.rb

require 'make_menu'

MakeMenu.run do |menu|
  # Block called before each time the menu redraws
  menu.header do
    puts
    puts 'A   T   T        '.bold.red.align(:center)
    puts ' L   H   H  N    '.bold.yellow.align(:center)
    puts '  L   E   I  G   '.bold.green.align(:center)
    puts '              S  '.bold.green.align(:center)
    puts
    puts " version #{`bump current`.strip} ".blue_bg.light_yellow.align(:center)
    puts
  end

  # All options shown here with their defaults
  menu.options do
    {
      group_title_color: :underline,
      clear_screen: true,
      pause_on_success: false,
      badges_first: true
    }
  end

  # Any matching text within the menu body is colored as defined here
  menu.highlights do
    {
      'thing' => :underline,
      'Do' => :bold,
      'Kill' => %i[red_bg light_yellow bold]
    }
  end

  # BADGES are displayed between the header and the menu body in a wrapping horizontal line
  # e.g.
  #   [LABEL][value]  [LABEL][value]  [LABEL][value]
  # 
  menu.add_badge 'SERVER = ' do
    if process_running? 'my_lovely_server'
      ' ON-LINE '.green_bg.bold
    else
      ' OFFLINE '.red_bg.dark
    end
  end

  # FIELDS are displayed between the header and the menu body in a vertical stack
  # e.g.
  #   [     LABEL][value            ]
  #   [LONG_LABEL][value            ] 
  #   [     OTHER][really long value]
  # 
  menu.add_field 'Random number: ' do
    rand(100).to_s
  end
  
  # This one reads the value from a file
  menu.add_field 'Contents of MyFile.txt: ', 
                 value_from_file: 'MyFile.txt', 
                 color: :green,
                 none: '[none]'.dark

  def process_running?(name)
    !`ps aux | grep #{name} | grep -v grep`.empty?
  end
end
```

Then open the menu with:

```bash
ruby menu.rb
```

## Colors

MakeMenu monkey-patches `String` with some cosmetic methods.

You can align a string relative to the terminal width:

```ruby
str.align(:center)
```

Or for a multi-line string:

```ruby
str.align_block(:center)
```

NOTE: You can't use the standard Ruby `ljust` etc. if the string contains colour codes.

You can change the colo(u)r of the text:

```ruby
str.color(:red)
```

Or add multiple colors:

```ruby
str.color([:red_bg, :yellow, :bold])
```

Or use the color names as chained method calls:

```ruby
str.red_bg.yellow.bold
```

The following colors are available:

```text
white
normal
bold
dark
underline
blink
invert
black

red
green
yellow
blue
magenta
cyan
grey

black_bg
red_bg
green_bg
yellow_bg
blue_bg
magenta_bg
cyan_bg
grey_bg

dark_grey
light_red
light_green
light_yellow
light_blue
light_magenta
light_cyan
light_grey

dark_grey_bg 
light_red_bg 
light_green_bg 
light_yellow_bg 
light_blue_bg 
light_magenta_bg 
light_cyan_bg 
light_grey_bg
```
