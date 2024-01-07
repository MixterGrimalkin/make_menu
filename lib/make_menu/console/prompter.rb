# frozen_string_literal: true

require 'io/console'

module MakeMenu
  module Console
    module Prompter
      PressedEscape = Class.new(StandardError)

      def self.prompt(text = '', obscure: false)
        print text

        input = ''
        char = ''

        until !char.empty? && char.ord == 13
          char = $stdin.getch

          case char.ord
          when 127
            # BACKSPACE
            input = input[0..-2]
            print "\r#{text}#{' ' * input.size} "
            print "\r#{text}#{obscure ? '*' * input.size : input}"

          when 27
            # ESC
            raise PressedEscape

          when 13
            # ENTER

          else
            input += char
            if obscure
              print '*'
            else
              print char
            end
          end
        end

        input
      end
    end
  end
end
