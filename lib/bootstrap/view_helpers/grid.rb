module Bootstrap
  module ViewHelpers
    class Grid < Base
      self.helper_names = 'grid'

      def row *args, &block
        GridRow.new(@view, *args, &block).render
      end

      after_initialize {add_class 'container'}
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

      after_initialize {add_class 'row'}
    end

    class GridCell < Base
      include Column

      def row *args, &block
        GridRow.new(@view, *args, &block).render
      end

      after_initialize do
        re = /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))[-_]?(?<act>offset|push|pull)[-_]?(?<num>\d{1,2})$/
        @args.extract!(Symbol, {and: [re]}).each do |arg|
          m = re.match arg.to_s
          size = SIZES[m[:size][0]]
          add_class "col-#{size}-#{m[:act]}-#{m[:num]}" unless have_class?(/^col-#{size}-#{m[:act]}-\d{1,2}/)
        end
        add_class 'col-md-3' if have_no_class?(/^col-(xs|sm|md|lg)-\d{1,2}$/)
      end
    end
  end
end