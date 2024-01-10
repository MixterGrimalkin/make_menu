# frozen_string_literal: true

require_relative 'builder'
require_relative 'badge_set'
require_relative 'field_set'
require_relative 'menu_item_group'
require_relative 'text/table'
require_relative 'console/prompter'

module MakeMenu
  # This class builds and displays a number-selection menu from a Makefile
  # then prompts for a number and executes the target.
  class Menu
    def initialize(makefile)
      @makefile = makefile

      @groups = []
      @items = []

      @options = {
        group_title_color: :underline,
        clear_screen: true,
        pause_on_success: false,
        badges_first: true
      }
      @highlights = {}

      @header = nil
      @field_set = nil
      @badge_set = nil
    end

    attr_reader :makefile, :groups, :items, :options, :highlights

    def run
      yield self if block_given?

      Builder.build(makefile, self)

      loop do
        system 'clear' if clear_screen?

        display_header
        display_badges
        display_fields

        if badges_first?
          display_badges
          display_fields
        else
          display_fields
          display_badges
        end

        puts colorize(MakeMenu::Text::Table.new(groups).to_s)
        puts
        puts 'Press ESC to quit'.align(:center).bold
        puts

        prompt = 'Select option: '.align(:center)

        begin
          execute_option(MakeMenu::Console::Prompter.prompt(prompt).strip)
          puts
        rescue MakeMenu::Console::Prompter::PressedEscape
          break
        end
      end

      puts

      system 'clear' if clear_screen?
    end

    def execute_option(selected)
      selected = selected.to_i

      items.each do |item|
        next unless item.option_number == selected

        system 'clear' if clear_screen?

        item.execute

        if pause_on_success?
          puts "\nPress ENTER to continue....".dark
          gets
        end
      end
    end

    def header(&block)
      @header = block
    end

    def display_header
      if @header
        @header.call
      else
        logo = "  #{Dir.pwd.split('/').last.upcase}  ".invert.bold.to_s
        puts "\n#{logo.align(:center)}\n \n"
      end
    end

    def add_field(label = '', value_from_file: nil, color: :normal, none: '[none]'.dark, &block)
      fields.add label, value_from_file: value_from_file, color: color, none: none, &block
    end

    def fields
      @field_set ||= FieldSet.new
    end

    def display_fields
      @field_set.display if @field_set
    end

    def add_badge(label = '', &block)
      badges.add label, &block
    end

    def badges
      @badge_set ||= BadgeSet.new
    end

    def display_badges
      @badge_set.display if @badge_set
    end

    def options
      @options.merge!(yield) if block_given?
      @options
    end

    def highlights
      @highlights.merge!(yield) if block_given?
      @highlights
    end

    def add_group(group)
      groups << group
      group
    end

    def add_item(item)
      items << item
      item
    end

    def group_title_color
      options[:group_title_color]
    end

    def clear_screen?
      options[:clear_screen]
    end

    def pause_on_success?
      options[:pause_on_success]
    end

    def badges_first?
      options[:badges_first]
    end

    def colorize(text)
      highlights.each do |word, color|
        case color
        when Array
          color.each { |c| text.gsub!(word, word.send(c)) }
        else
          text.gsub!(word, word.send(color))
        end
      end
      text
    end
  end
end
