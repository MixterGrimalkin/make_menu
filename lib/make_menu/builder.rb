# frozen_string_literal: true

module MakeMenu
  module Builder
    # Parse `makefile` and add all annotated targets to `menu`
    def self.build(makefile, menu)
      File.open(makefile, 'r') do |file|
        option_number = 1
        current_group = nil

        file.each_line do |line|
          if line.start_with? '###'
            # Group header
            group_title = line.gsub(/###\s+/, '').strip
            current_group = menu.add_group MenuItemGroup.new(group_title.color(menu.group_title_color))

          elsif line.match(/^[a-zA-Z_-]+:.*?## .*$$/)
            # Menu item
            target = line.split(':').first.strip
            description = line.split('##').last.strip

            # Target 'menu' should not appear
            next if target == 'menu'

            current_group ||= menu.add_group MenuItemGroup.new('Commands'.color(menu.group_title_color))

            menu.add_item current_group.add_item(MenuItem.new(option_number, target, description))

            option_number += 1
          end
        end

        if option_number == 1
          puts
          puts 'No annotated targets found!'.red.bold
          puts
          puts 'Expecting something like this....'
          puts "    #{'my_target:'.cyan} #{'## Do some things'.yellow}"
          puts
          exit 1
        end
      end
    rescue Errno::ENOENT => _e
      puts
      puts 'No Makefile!'.red.bold
      puts
      puts "File '#{makefile}' could not be found.".yellow
      puts
      exit 1
    end
  end
end
