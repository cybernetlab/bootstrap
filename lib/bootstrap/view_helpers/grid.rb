module Bootstrap
  #
  module ViewHelpers
    #
    # Grid
    #
    # @author [alexiss]
    #
    class Grid < WrapIt::Container
      html_class 'container'
      child :row, 'Bootstrap::ViewHelpers::GridRow'
    end

    #
    # GridRow
    #
    # @author [alexiss]
    #
    class GridRow < WrapIt::Container
      #
      # Clearfix
      #
      # @author [alexiss]
      #
      class Clearfix < WrapIt::Base
        TYPES = %w(visible-xs visible-sm visible-md visible-lg
                   hidden-xs hidden-sm hidden-md hidden-lg)
        REGEXP = /\A
            (?:visible|hidden)
            [-_]?
            (?:(?:extra[-_]?small)|xs|small|sm|medium|md|large|lg)
          \z/xi
        html_class 'clearfix'
        after_initialize do
          type = @arguments.extract_first!(Symbol, String, and: [REGEXP]) ||
            'visible-md'
          type ||= @options[:type]
          @options.delete(:type)
          type = type.to_s.downcase
            .gsub(/_/, '-')
            .gsub(/extra-?small/, 'xs')
            .gsub(/small/, 'sm')
            .gsub(/medium/, 'md')
            .gsub(/large/, 'lg')
          TYPES.include?(type) || type = 'visible-md'
          add_html_class type
        end
      end

      html_class 'row'
      child :cell, 'Bootstrap::ViewHelpers::GridCell'
      child :clear, 'Bootstrap::ViewHelpers::GridRow::Clearfix'
    end

    #
    # GridCell
    #
    # @author [alexiss]
    #
    class GridCell < WrapIt::Container
      include SizableColumn
      include PlacableColumn
      include WrapIt::TextContainer

      default_tag 'div'
      child :row, 'Bootstrap::ViewHelpers::GridRow'

      before_capture do
        column_size_defined? || add_html_class('col-md-3')
      end
    end

    WrapIt.register :grid, 'Bootstrap::ViewHelpers::Grid'
  end
end
