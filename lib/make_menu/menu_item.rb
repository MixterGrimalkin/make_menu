# frozen_string_literal: true

module MakeMenu
  # This class represents an option in the menu which runs a target from the Makefile
  class MenuItem
    INDENT = 6

    def initialize(option_number = nil, target = nil, description = nil)
      @option_number = option_number
      @target = target
      @description = description || target
    end

    attr_reader :option_number, :target, :description

    def execute
      cmd = ['make', target]
      puts "> #{cmd.join(' ').cyan}\n"
      unless system(*cmd)
        # Indicates the command failed, so we pause to allow user to see error message
        puts "\nPress ENTER to continue....".dark
        gets
      end
    rescue StandardError => _e
      # Sink keyboard interrupt from within Make target
    end

    # @return [Integer] Number of characters required to display the item
    def width
      description.size + INDENT + 1
    end

    # @return [String] Text to display for this item
    def to_s
      "#{option_number.to_s.rjust(INDENT, ' ').bold}.  #{description}"
    end
  end
end
