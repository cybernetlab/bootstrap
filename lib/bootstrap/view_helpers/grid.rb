module Bootstrap
  module ViewHelpers
    class Grid < Base
      html_class 'container'
      helper :row, 'Bootstrap::ViewHelpers::GridRow'
    end

    class GridRow < Base
      html_class 'row'
      helper :cell, 'Bootstrap::ViewHelpers::GridCell'

      def clear type = 'visible-md'
        type = type.to_s.downcase.gsub(/_/, '-').gsub(/extra-?small/, 'xs').gsub(/small/, 'sm').gsub(/medium/, 'md').gsub(/large/, 'lg')
        type = 'visible-md' unless %w[visible-xs visible-sm visible-md visible-lg hidden-xs hidden-sm hidden-md hidden-lg].include? type
        @view.concat @view.content_tag 'div', '', class: ['clearfix', type]
      end
    end

    class GridCell < Base
      include SizableColumn
      include PlacableColumn
      include TextContainer

      TAG = 'div'
      helper :row, 'Bootstrap::ViewHelpers::GridRow'

      set_callback :capture, :before do
        add_class 'col-md-3' unless column_size_defined?
        true
      end
    end

    register_helper :grid, 'Bootstrap::ViewHelpers::Grid'
  end
end