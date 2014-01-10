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
      include Column
      include TextContainer

      TAG = 'div'
      helper :row, 'Bootstrap::ViewHelpers::GridRow'

      after_initialize do
        re = /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))[-_]?(?<act>offset|push|pull)[-_]?(?<num>\d{1,2})$/
        @args.extract!(Symbol, {and: [re]}).each do |arg|
          m = re.match arg.to_s
          size = SIZES[m[:size][0]]
          add_class "col-#{size}-#{m[:act]}-#{m[:num]}" unless have_class?(/^col-#{size}-#{m[:act]}-\d{1,2}/)
        end
      end

      set_callback :capture, :before do
        add_class 'col-md-3' unless have_class?(/^col-(xs|sm|md|lg)-\d{1,2}$/)
        true
      end
    end

    register_helper :grid, 'Bootstrap::ViewHelpers::Grid'
  end
end