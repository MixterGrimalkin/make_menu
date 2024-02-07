# frozen_string_literal: true

require 'io/console'

module MakeMenu
  module Console
    module Prompter
      PressedEscape = Class.new(StandardError)

      def self.prompt_and_save(text, file:, obscure: false)
        if file.is_a? Symbol
          file = ".#{file}"
        end

        current = File.exists?(file) ? File.read(file).strip : ''

        response = prompt(text, input: current, obscure: obscure)

        if response.empty?
          File.delete(file) if File.exists?(file)
        else
          File.write(file, response)
        end

        return response
      end

      def self.prompt(text = '', input: '', obscure: false, value_color: :light_yellow)
        text = text.bold

        print "\r#{text}#{input.color(value_color)}"

        char = ''

        until !char.empty? && char.ord == 13
          char = $stdin.getch

          case char.ord
          when 127
            # BACKSPACE
            input = input[0..-2]
            print "\r#{text}#{' ' * input.size} "
            print "\r#{text}#{obscure ? '*'.color(value_color) * input.size : input.color(value_color)}"

          when 27
            # ESC
            raise PressedEscape if input.empty?

            print "\r#{text}#{' ' * input.size} "
            print "\r#{text}"

            input = ''
            char = ''

          when 13
            # ENTER

          else
            input += char
            if obscure
              print '*'.color(value_color)
            else
              print char.color(value_color)
            end
          end
        end

        print "\r#{text}#{' ' * input.size} "
        print "\r#{text}"

        input
      end
    end
  end
end
