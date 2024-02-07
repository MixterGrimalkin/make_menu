# frozen_string_literal: true

module MakeMenu
  # A set of FIELDS to display above the menu
  class FieldSet
    def initialize
      @fields = []
      @max_widths = {}
    end

    # Add a new field to the set
    # @param [String] label Optional label to print to the left of the field value
    # @param [String,Symbol] value_from_file If set, read the field value from a file
    #   in the current directory. A String is used literally, a Symbol is assumed
    #   to be a hidden file (i.e. starts with `.`)
    # @param [String,Symbol,Integer] color Formatting to apply to the value
    # @param [String] none Text to display if the file does not exist, or is empty
    # @param [Proc] block Block to return the value to display
    def add(label = '', value_from_file: nil, color: :normal, none: '[none]'.dark, &block)
      if value_from_file
        if value_from_file.is_a? Symbol
          value_from_file = ".#{value_from_file}"
        end
        block = lambda do
          if File.exists? value_from_file
            value = File.read(value_from_file).strip

            return none if value.empty?

            return value.color(color)
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

    # Print fields in an aligned vertical stack
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

    private

    # Calculate maximum sizes of labels and rendered values
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
  end
end
