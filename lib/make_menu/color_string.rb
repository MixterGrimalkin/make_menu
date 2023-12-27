# frozen_string_literal: true

module MakeMenu
  # Monkeypatch for `String`, adds methods to change console text colo(u)r
  module ColorString
    COLORS = {
      white: 0,
      normal: 0,
      bold: 1,
      dark: 2,
      underline: 4,
      blink: 5,
      invert: 7,

      black: 30,
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36,
      grey: 37,

      black_bg: 40,
      red_bg: 41,
      green_bg: 42,
      yellow_bg: 43,
      blue_bg: 44,
      magenta_bg: 45,
      cyan_bg: 46,
      grey_bg: 47,

      dark_grey: 90,
      light_red: 91,
      light_green: 92,
      light_yellow: 93,
      light_blue: 94,
      light_magenta: 95,
      light_cyan: 96,
      light_grey: 97,

      dark_grey_bg: 100,
      light_red_bg: 101,
      light_green_bg: 102,
      light_yellow_bg: 103,
      light_blue_bg: 104,
      light_magenta_bg: 105,
      light_cyan_bg: 106,
      light_grey_bg: 107
    }.freeze

    COLORS.each do |name, code|
      define_method name do
        color(code)
      end
    end

    # Apply specified color code to the String
    # @param [Array, Symbol, Integer] color_code Can be a key in the COLORS array,
    #     an integer ANSI code for text color, or an array of either to be applied in order
    # @return [String] String enclosed by formatting characters
    def color(color_code)
      case color_code
      when Array
        color_code.inject(self) { |string, code| string.color(code) }
      when Symbol
        color(COLORS[color_code])
      else
        "\e[#{color_code}m#{self}\e[0m"
      end
    end

    # Changes all occurrences of a specified character to one color,
    # and all other characters to another
    # @param [String] char Character to highlight
    # @param [Symbol] fore_color Key of color to use for highlighted character
    # @param [Symbol] back_color Key of color to use for other characters
    # @return [String] Highlighted text
    # @example "==$$==".highlight('$', :light_yellow, :red)
    # rubocop:disable Metrics/MethodLength
    def highlight(char, fore_color, back_color)
      inside_highlight = false
      output = ''
      buffer = ''
      each_char do |c|
        if c == char
          unless inside_highlight
            output += buffer.color(COLORS[back_color.to_sym])
            buffer = ''
            inside_highlight = true
          end
        elsif inside_highlight
          output += buffer.color(COLORS[fore_color.to_sym]).bold
          buffer = ''
          inside_highlight = false
        end
        buffer += c
      end

      output += if inside_highlight
                  buffer.color(COLORS[fore_color.to_sym]).bold
                else
                  buffer.color(COLORS[back_color.to_sym])
                end

      output
    end
    # rubocop:enable Metrics/MethodLength

    # Remove color codes from the string
    # @return [String] The modified string
    def decolor
      gsub(/\e\[\d+m/, '')
    end

    # Align the string, ignoring color code characters which would otherwise mess up String#center, etc.
    # @param [Symbol] alignment :left, :center, or :right
    # @param [Integer] width The number of characters to spread the string over (default to terminal width)
    # @param [String] char The character to use for padding
    # @param [Boolean] pad_right Set true to include trailing spaces when aligning to :center
    # @return [String] The padded string
    # rubocop:disable Metrics/MethodLength
    def align(alignment = :left, width: nil, char: ' ', pad_right: false)
      width = ::TTY::Screen.cols unless width

      case alignment
      when :left
        right_pad = width - decolor.length
        "#{self}#{char * right_pad}"
      when :center
        left_pad = [(width - decolor.length) / 2, 0].max
        right_pad = width - left_pad - decolor.length
        "#{char * left_pad}#{self}#{pad_right ? char * right_pad : ''}"
      when :right
        left_pad = width - decolor.length
        "#{char * left_pad}#{self}"
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
