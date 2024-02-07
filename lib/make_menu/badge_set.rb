# frozen_string_literal: true

module MakeMenu
  # A set of BADGES to display above the menu
  class BadgeSet
    def initialize
      @badges = []
    end

    # Add a new badge to the set
    # @param [String] label Optional label to print to the left of the badge value
    # @param [Proc] block Block to run each time the menu is re-drawn
    def add(label = '', &block)
      @badges << {
        label: label,
        handler: block
      }
    end

    # Print badges in a wrapping horizontal row
    def display
      rows = []
      row = ''
      @badges.each do |badge|
        label = badge[:label]
        value = badge[:handler].call
        if row.decolor.size + label.decolor.size + value.decolor.size >= (0.7 * ::TTY::Screen.cols)
          rows << row
          row = ''
        end
        row += " #{label}#{value} "
      end
      rows << row

      puts rows.join("\n\n").align_block(:center)
      puts
    end
  end
end
