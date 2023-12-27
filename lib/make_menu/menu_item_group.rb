# frozen_string_literal: true

require_relative 'menu_item'

module MakeMenu
  # This class represents a group of menu items, with a title line
  class MenuItemGroup
    INDENT = 2

    # @param [String] title The title text to display at the top of the group
    def initialize(title = 'Commands')
      @title = title
      @items = []
    end

    attr_reader :title, :items

    # Add a new item to the group
    # @param [MenuItem] item The item to add
    # @return [MenuItem] The added item
    def add_item(item)
      items << item
      item
    end

    # @return [Integer] Number of characters needed to display the widest item
    def width
      [items.map(&:width).max, title.length + INDENT].max
    end

    # @return [Integer] Number of rows needed to display the group
    def height
      items.size + 2
    end

    # @return [String] Text representation of group
    def to_s
      result = "#{' ' * INDENT}#{title}\n"

      items.each do |item|
        result += "#{item}\n"
      end

      "#{result} "
    end
  end
end
