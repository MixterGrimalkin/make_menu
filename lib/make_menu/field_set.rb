module MakeMenu
  class FieldSet
    def initialize
      @fields = []
      @max_widths = {}
    end

    def display
      build
      @fields.each do |field|
        label_cell = field[:label]
                       .align(
                         :right,
                         width: @max_widths[:label]
                       )

        value_cel = field[:value]
                      .align(
                        :left,
                        width: @max_widths[:value],
                        pad_right: true
                      )

        puts "#{label_cell}#{value_cel}".align(:center)
      end
      puts
    end

    def build
      @max_widths[:label] = 0
      @max_widths[:value] = 0

      @fields.each do |field|
        label = field[:label]
        value = field[:value] = field[:handler].call
        label_width = label.decolor.size
        value_width = value.decolor.size
        @max_widths[:label] = label_width if label_width > @max_widths[:label]
        @max_widths[:value] = value_width if value_width > @max_widths[:value]
      end
    end

    def add(label = '', value_from_file: nil, color: :normal, none: '[none]'.dark, &block)
      if value_from_file
        block = lambda do
          if File.exists? value_from_file
            return File.read(value_from_file).strip.color(color)
          else
            return none
          end
        end
      end

      @fields << {
        label: label,
        handler: block
      }
    end
  end
end
