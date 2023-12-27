# frozen_string_literal: true

require_relative 'menu_item_group'
require_relative 'color_string'
require_relative 'text_table'

module MakeMenu
  # This class builds and displays a number-selection menu from a Makefile
  # then prompts for a number and executes the target.
  class Menu
    # @param [String] makefile Makefile name
    def initialize(makefile)
      @groups = []
      @items = []
      @status_present = false
      build makefile
    end

    attr_reader :groups, :items
    attr_accessor :status_present

    # Display menu and prompt for command
    # rubocop:disable Metrics/MethodLength
    def run
      running = true

      while running
        system 'clear' if clear_screen?

        display_header

        puts colorize(TextTable.new(groups).to_s)
        puts
        puts 'Press ENTER to quit'.align(:center).bold
        puts
        print 'Select option: '.align(:center)

        running = false unless execute_option(gets.strip)
      end

      puts

      system 'clear' if clear_screen?
    end

    # rubocop:enable Metrics/MethodLength

    # Display the company logo and the status bar (if set)
    def display_header
      puts formatted_logo if logo
      puts `make status` if status_present
    end

    private

    # Build a menu from the specified Makefile
    # @param [String] makefile Filename
    # rubocop:disable Metrics/MethodLength
    def build(makefile)
      File.open(makefile, 'r') do |file|
        option_number = 1
        current_group = nil

        file.each_line do |line|
          if line.start_with? '###'
            # Group header
            group_title = line.gsub(/###\s+/, '').strip
            current_group = MenuItemGroup.new(group_title.color(group_title_color))
            groups << current_group

          elsif line.match(/^[a-zA-Z_-]+:.*?## .*$$/)
            # Menu item
            target = line.split(':').first.strip
            description = line.split('##').last.strip

            # Target 'menu' should not appear
            next if target == 'menu'

            # Target 'status' should not appear, but is run automatically when the menu is rendered
            if target == 'status'
              self.status_present = true
              next
            end

            unless current_group
              current_group = MenuItemGroup.new
              groups << current_group
            end

            items << current_group.add_item(
              MenuItem.new(option_number, target, description)
            )

            option_number += 1
          end
        end
      end
    end

    # rubocop:enable Metrics/MethodLength

    # Execute the selected menu item
    # @param [String] selected Value entered by user
    # @return [Boolean] False to signify that menu should exit
    def execute_option(selected)
      return false if selected.empty?

      selected = selected.to_i

      items.each do |item|
        next unless item.option_number == selected

        system 'clear' if clear_screen?
        item.execute
        return true
      end

      true
    end

    # Apply word colorings
    # @param [String] string
    # @return [String]
    def colorize(string)
      return string unless Object.const_defined?("#{self.class.name}::HIGHLIGHTS")

      Object.const_get("#{self.class.name}::HIGHLIGHTS").each do |word, color|
        case color
        when Array
          color.each { |c| string.gsub!(word, word.send(c)) }
        else
          string.gsub!(word, word.send(color))
        end
      end
      string
    end

    # Center each line of the logo across the screen
    def formatted_logo
      logo.split("\n")
          .map { |line| line.align(:center) }
          .join("\n")
    end

    # Get the menu logo from the LOGO constant
    def logo
      return "\n#{' make '.black_bg.light_yellow}#{' menu '.light_yellow_bg.black}\n".bold unless Object.const_defined?("#{self.class.name}::LOGO")

      Object.const_get("#{self.class.name}::LOGO")
    end

    protected

    # Override the following methods to customise the menu display
    1
    # @return [Symbol] Color for group title
    def group_title_color
      :bold
    end

    # Clean screen before and after each command
    def clear_screen?
      true
    end
  end
end
