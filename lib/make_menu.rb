# frozen_string_literal: true

require_relative 'make_menu/console/prompter'
require_relative 'make_menu/console/color_string'
require_relative 'make_menu/menu'

require 'tty-screen'

module MakeMenu
  String.include MakeMenu::Console::ColorString

  trap('SIGINT') { throw StandardError }

  def self.run(makefile = './Makefile', &block)
    MakeMenu::Menu.new(makefile).run(&block)
  end

  def self.prompt(text = nil, obscure: false, value_from_file: nil)
    if (preamble = ARGV[0])
      if text.nil?
        if preamble.include?("\n")
          parts = preamble.split("\n")
          preamble = parts[0..-2].join("\n")
          text = parts[-1]
          puts preamble
        else
          text = preamble
        end
      end
    end

    if value_from_file
      begin
        input = Console::Prompter.prompt_and_save text, file: value_from_file, obscure: obscure
        puts (obscure ? ('*' * input.decolor.size) : input).green.underline

      rescue Console::Prompter::PressedEscape
        puts '(not updated)'.red
      end
    else
      begin
        input = Console::Prompter.prompt text, obscure: obscure
        puts (obscure ? ('*' * input.decolor.size) : input).green.underline
        $stderr.puts input
      rescue Console::Prompter::PressedEscape
        puts '(not updated)'.red
      end
    end

    input
  end
end
