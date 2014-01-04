module Bootstrap
  module ViewHelpers
    class Grid < Base
      def row *args, &block
        GridRow.new(@view, *args, &block).render
      end

      def self.helper_names
        'grid'
      end

      set_callback :initialize, :after do
        add_class 'container'
      end
    end

    class GridRow < Base
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

      set_callback :initialize, :after do
        add_class 'row'
      end
    end

    class GridCell < Base
      include Column

      def row *args, &block
        GridRow.new(@view, *args, &block).render
      end

      def self.helper_names
        nil
      end

      set_callback :initialize, :after do
        @args.each do |arg|
          next unless /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))[-_]?(?<act>offset|push|pull)[-_]?(?<num>\d{1,2})$/ =~ arg
          size = SIZES[size[0]]
          add_class "col-#{size}-#{act}-#{num}" unless @options[:class].any? {|c| /^col-#{size}-#{act}-\d{1,2}/ =~ c}
        end
        add_class 'col-md-3' if options[:class].none? {|c| /^col-(xs|sm|md|lg)-\d{1,2}$/ =~ c}
      end
    end
  end
end