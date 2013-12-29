module Bootstrap
  module ViewHelpers
    class Grid < Base
      def render
        add_class 'container'
        @view.content_tag @tag, capture, @options
      end

      def row *args, &block
        GridRow.new(@view, *args, &block).render
      end

      def self.helper_names
        'grid'
      end
    end

    class GridRow < Base
      def render
        add_class 'row'
        @view.content_tag @tag, capture, @options
      end

      def cell *args, &block
        GridCell.new(@view, *args, &block).render
      end

      def clear type = 'visible-md'
        type = type.to_s.downcase.gsub(/_/, '-').gsub(/extra-?small/, 'xs').gsub(/small/, 'sm').gsub(/medium/, 'md').gsub(/large/, 'lg')
        type = 'visible-md' unless %w[visible-xs visible-sm visible-md visible-lg hidden-xs hidden-sm hidden-md hidden-lg].include? type
        @view.content_tag 'div', '', class: ['clearfix', type]
      end

      def self.helper_names
        nil
      end
    end

    class GridCell < Base
      def initialize view, *args, &block
        no_class = true
        super.each do |arg|
          next unless arg.is_a?(String) || arg.is_a?(Symbol)
          arg = arg.to_s.downcase
          if /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))(?:[-_]?(?<act>offset|push|pull))?[-_]?(?<num>\d{1,2})$/ =~ arg
            size = {'x' => 'xs', 'e' => 'xs', 's' => 'sm', 'm' => 'md', 'l' => 'lg'}[size[0]]
            part = ['col', size, act].compact.join('-')
            add_class "#{part}-#{num}" unless @options[:class].any? {|c| /^#{part}-\d{1,2}/ =~ c}
            no_class = false if act.nil?
          end
        end
        add_class 'col-md-3' if no_class
      end

      def row *args, &block
        GridRow.new(@view, *args, &block).render
      end

      def render
        #add_class 'col-md-3'
        @view.content_tag @tag, capture, @options
      end

      def self.helper_names
        nil
      end
    end
  end
end