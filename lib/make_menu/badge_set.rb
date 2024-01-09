module MakeMenu
  class BadgeSet
    def initialize
      @badges = []
    end

    def display
      rows = []
      row = ''
      @badges.each do |badge|
        label = badge[:label]
        value = badge[:handler].call ? badge[:on] : badge[:off]
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

    def add(label = '', on: ' ON '.green_bg.bold, off: ' OFF '.red_bg.dark, &block)
      @badges << {
        label: label,
        on: on,
        off: off,
        handler: block
      }
    end
  end
end
