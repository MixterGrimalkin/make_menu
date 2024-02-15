# frozen_string_literal: true

module MakeMenu
  module Text
    SPACING = 2

    # A column of text with a fixed with
    class Column
      def initialize
        @width = nil
        @rows = []
        @row_index = 0
      end

      attr_accessor :rows, :row_index, :width

      # Add a block of text to the column. Each row will be padded to the column width
      def add(text)
        self.rows += text.split("\n").map do |row|
          self.width = row.decolor.size + SPACING unless width
          self.width = [width, row.decolor.size + SPACING].max
          row.gsub("\r", '')
        end
        self.row_index += text.lines.size
      end

      # @return [String] The row at the specified index
      def row(index)
        (rows[index] || '').align(width: width)
      end

      # @return [Integer] The number of rows in the column
      def height
        row_index
      end

      # @return [Boolean] True if the column is empty
      def empty?
        row_index.zero?
      end
    end
  end
end
