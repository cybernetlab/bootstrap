module Bootstrap
  module ViewHelpers
    class Table < Base
      self.flag :striped, html_class: 'table-striped'
      self.flag :bordered, html_class: 'table-bordered'
      self.flag :hover, html_class: 'table-hover'
      self.flag :condensed, html_class: 'table-condensed'
      self.flag(:responsive) {|value| self.wrapper = value ? {tag: 'div', class: 'table-responsive'} : nil}

      html_class 'table'
      helper :row, 'Bootstrap::ViewHelpers::TableRow'

      after_initialize {@tag = 'table'}
    end

    class TableRow < Base
      include Contextual

      helper :cell, 'Bootstrap::ViewHelpers::TableCell'
      alias_method :td, :cell

      helper(:head, 'Bootstrap::ViewHelpers::TableCell') {|cell| cell.tag = 'th'}
      alias_method :th, :head
      alias_method :header, :head

      after_initialize {@tag = 'tr'}
    end

    class TableCell < Base
      include Column
      include Contextual
      include TextContainer

      after_initialize do
        header = !@args.extract_first!([:header, :head, :th]).nil?
        header = [header, options.delete(:header) == true, options.delete(:head) == true, options.delete(:th) == true].any?
        @tag = (header || @tag == 'th') ? 'th' : 'td'
      end
    end

    register_helper :table, 'Bootstrap::ViewHelpers::Table'
  end
end