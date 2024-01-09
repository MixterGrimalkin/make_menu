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
                       ).color(field[:label_color])

        value_cel = field[:value]
                      .align(
                        :left,
                        width: @max_widths[:value],
                        pad_right: true
                      ).color(field[:value_color])

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

    def add(label = nil, label_color: :normal, value_color: :normal, &block)
      @fields << {
        label: label || '',
        label_color: label_color,
        value_color: value_color,
        handler: block
      }
    end
  end
end
