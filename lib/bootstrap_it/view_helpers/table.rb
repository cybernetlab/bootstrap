module BootstrapIt
  #
  module ViewHelpers
    #
    # Table
    #
    # @author [alexiss]
    #
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

      # TODO: remove it since WrapIt 0.1.5
      def unwrap
        @wrapper = nil
      end
    end

    #
    # TableRow
    #
    # @author [alexiss]
    #
    class TableRow < WrapIt::Container
      include Contextual

      child :cell, 'BootstrapIt::ViewHelpers::TableCell'
      alias_method :td, :cell

      child :head, 'BootstrapIt::ViewHelpers::TableCell', [tag: 'th']
      alias_method :th, :head
      alias_method :header, :head

      after_initialize { @tag = 'tr' }
    end

    #
    # TableCell
    #
    # @author [alexiss]
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

    WrapIt.register :table, 'BootstrapIt::ViewHelpers::Table'
  end
end
