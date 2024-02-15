# frozen_string_literal: true

require_relative 'column'

module MakeMenu
  module Text
    # This class displays the menu groups in columns across the screen.
    # Each group is kept together in a column, and once a column has exceeded the
    # calculated height, a new column is added.
    class Table
      MAX_COLUMNS = 4

      # @param [Array<MenuItemGroup>] groups
      def initialize(groups)
        @groups = groups
        @columns = []
        calculate_table_dimensions
        build_table
      end

      # @return [String] The entire table, centered on the screen
      def to_s
        buffer = ''

        max_height.times do |i|
          row = ''
          columns.each do |column|
            row += column.row(i) unless column.empty?
          end
          buffer += "#{row.align(:center)}\n"
        end

        buffer
      end

      private

      attr_reader :groups, :columns, :column_width, :column_height

      attr_accessor :current_column

      # Calculate width and minimum height of columns
      def calculate_table_dimensions
        @column_width = groups.map(&:width).max + 5
        total_rows = groups.map(&:height).sum
        column_count = (::TTY::Screen.cols / column_width).clamp(1, MAX_COLUMNS)
        @column_height = total_rows / column_count
      end

      # Build columns from groups
      def build_table
        column_break
        groups.each do |group|
          add_text_block group.to_s
        end
      end

      # Add a block of text to the current column. If the column is now larger than
      # the minimum height, a new column is added
      def add_text_block(text)
        current_column.add(text)
        column_break if current_column.height >= column_height
      end

      # Add a new column to the table
      def column_break
        self.current_column = Column.new
        columns << current_column
      end

      # @return [Integer] Maximum column height (rows)
      def max_height
        columns.map(&:height).max
      end
    end
  end
end
