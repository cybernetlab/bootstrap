module Bootstrap
  module ViewHelpers
    class Table < Base
      self.helper_names = 'table'

      def row *args, &block
        TableRow.new(@view, *args, &block).render
      end

      set_callback :initialize, :after do
        @responsive = false
        @args.each do |arg|
          if SWITCHERS.include? arg.to_sym
            instance_variable_set "@#{arg}".to_sym, true
          end
        end
        SWITCHERS.each do |switch|
          instance_variable_set "@#{switch}".to_sym, options.delete(switch) == true if @options.key? switch
        end
        @bordered = true if options.delete(:border) == true
        add_class 'table'
        add_class 'table-striped' if @striped
        add_class 'table-bordered' if @bordered
        add_class 'table-hover' if @hover
        add_class 'table-condensed' if @condensed
        @tag = 'table'
        self.wrapper = {tag: 'div', class: 'table-responsive'} if @responsive
      end

      private
      SWITCHERS = %i[responsive striped bordered hover condensed]
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

      set_callback :initialize, :after do
        @tag = 'tr'
      end
    end

    class TableCell < Base
      include Column

      set_callback :initialize, :after do
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