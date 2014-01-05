module Bootstrap
  module ViewHelpers
    class Table < Base
      self.helper_names = 'table'

      self.flag :striped, html_class: 'table-striped'
      self.flag :bordered, html_class: 'table-bordered'
      self.flag :hover, html_class: 'table-hover'
      self.flag :condensed, html_class: 'table-condensed'
      self.flag(:responsive) {|value| self.wrapper = value ? {tag: 'div', class: 'table-responsive'} : nil}

      def row *args, &block
        TableRow.new(@view, *args, &block).render
      end

      after_initialize do
        add_class 'table'
        @tag = 'table'
      end
    end

    class TableRow < Base
      include Contextual

      def cell *args, &block
        TableCell.new(@view, *args, &block).render
      end
      alias_method :td, :cell

      def head *args, &block
        args.unshift :head
        TableCell.new(@view, *args, &block).render
      end
      alias_method :th, :head
      alias_method :header, :head

      after_initialize {@tag = 'tr'}
    end

    class TableCell < Base
      include Column

      after_initialize do
        header = false
        @args.each do |arg|
          header = arg == 'header' || arg == 'head' || arg == 'th'
          break if header
        end
        header = [header, options.delete(:header) == true, options.delete(:head) == true, options.delete(:th) == true].any?
        @tag = (header || @tag == 'th') ? 'th' : 'td'
      end
    end
  end
end