# frozen_string_literal: true

require_relative 'color_string'
require 'readline'

module MakeMenu
  # A panel above the menu displaying the status of Docker containers.
  # The mapping of TextLabel => ContainerName must be defined in a constant called CONTAINERS
  class StatusPanel
    String.include(ColorString)

    # Print panel
    def display
      return if containers.empty?

      puts "\n#{panel}"
    end

    protected

    # Return a hash mapping label to container name
    # This is assumed to be provided as a constant called CONTAINERS
    # @return [Hash{String=>String}]
    def containers
      Object.const_get "#{self.class.name}::CONTAINERS"
    rescue NameError
      {}
    end

    # Override this to change the colors for running / not running
    def colors_if_running
      {
        true => %i[green_bg bold white],
        false => %i[red_bg bold dark]
      }.freeze
    end

    # Override this to limit each row to a maximum number of labels
    def max_labels_per_line
      containers.size
    end

    private

    # @return [String] Text representation of the panel
    # rubocop:disable Metrics/MethodLength
    def panel
      return @panel if @panel

      return "- Docker offline -\n".grey.dark.align(:center) unless docker_online?

      @panel = ''
      labels_on_this_line = 0
      line_buffer = ''

      containers.each do |label, container|
        if (labels_on_this_line + 1) > labels_per_line
          @panel += "#{left_indent(labels_on_this_line)}#{line_buffer}\n\n"
          labels_on_this_line = 0
          line_buffer = ''
        end

        text = label.align(:center, width: max_label_width, pad_right: true)
                    .color(colors_if_running[running?(container)])

        line_buffer += " #{text} "

        labels_on_this_line += 1
      end

      @panel += "#{left_indent(labels_on_this_line)}#{line_buffer}\n\n"
    end
    # rubocop:enable Metrics/MethodLength

    def docker_online?
      system 'docker', 'compose', 'ps', out: File::NULL, err: File::NULL
    end

    # @return [String] List of Docker containers and information
    def docker_ps
      @docker_ps ||= `docker compose ps`
    end

    # @return [Boolean] whether specified container is running
    def running?(container)
      docker_ps.include? container
    end

    # Return the left indent for this line of labels
    # @param [Integer] number_of_labels Number of labels on this line
    # @return [String]
    def left_indent(number_of_labels)
      spaces = (::TTY::Screen.cols - (number_of_labels * (max_label_width + 2))) / 2
      spaces = [spaces, 0].max
      ' ' * spaces
    end

    # @return [Integer] Maximum label width, with padding
    def max_label_width
      @max_label_width ||= containers.map do |label, _container|
        label.length
      end.max + 2
    end

    # @return [Integer] Number of labels that can fit on one line
    def labels_per_line
      @labels_per_line ||= [
        (::TTY::Screen.cols / max_label_width) - 1,
        max_labels_per_line
      ].min
    end
  end
end
