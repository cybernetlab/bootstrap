module BootstrapIt
  #
  module ViewHelpers
    #
    # Table
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/css/#tables Bootstrap docs
    class Table < WrapIt::Container
      html_class 'table'
      html_class_prefix 'table-'

      switch :striped, html_class: true
      switch :bordered, html_class: true
      switch :hover, html_class: true
      switch :condensed, html_class: true
      switch :responsive do |value|
        value && wrap(class: 'table-responsive')
      end

      child :row, 'BootstrapIt::ViewHelpers::TableRow'

      after_initialize { @tag = 'table' }
    end

    #
    # TableRow
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class TableRow < WrapIt::Container
      include Contextual

      child :cell, 'BootstrapIt::ViewHelpers::TableCell'
      alias_method :td, :cell

      child :head, 'BootstrapIt::ViewHelpers::TableCell', tag: 'th'
      alias_method :th, :head
      alias_method :header, :head

      after_initialize { @tag = 'tr' }
    end

    #
    # TableCell
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class TableCell < WrapIt::Base
      include WrapIt::TextContainer
      include SizableColumn
      include Contextual

      after_initialize do
        header = !@arguments.extract_first!([:header, :head, :th]).nil?
        header ||= @options[:header] == true || @options[:head] == true ||
          @options[:th] == true
        @options.delete(:header)
        @options.delete(:head)
        @options.delete(:th)
        @tag = header || @tag == 'th' ? 'th' : 'td'
      end
    end

    register :table, 'BootstrapIt::ViewHelpers::Table'
  end
end
