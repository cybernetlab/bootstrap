module Bootstrap
  module ViewHelpers
    class Table < Base
      def row *args, &block
        TableRow.new(@view, *args, &block).render
      end

      def self.helper_names
        'table'
      end

      def render *args, &block
        @responsive ? @view.content_tag('div', super, class: 'table-responsive') : super
      end

      set_callback :initialize, :after do
        @responsive = false
        @args.each do |arg|
          if SWITCHERS.include? arg.to_sym
            instance_variable_set "@#{arg}".to_sym, true
          end
        end
        SWITCHERS.each do |switch|
          instance_variable_set "@#{switch}".to_sym, options.delete(switch).is_a?(TrueClass) if @options.include? switch
        end
        @bordered = true if options.delete(:border) == true
        add_class 'table'
        add_class 'table-striped' if @striped
        add_class 'table-bordered' if @bordered
        add_class 'table-hover' if @hover
        add_class 'table-condensed' if @condensed
        @tag = 'table'
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

      def self.helper_names
        nil
      end

      set_callback :initialize, :after do
        @tag = 'tr'
      end
    end

    class TableCell < Base
      include Column

      def self.helper_names; nil; end

      set_callback :initialize, :after do
        header = false
        @args.each do |arg|
          header = arg == 'header' || arg == 'head' || arg == 'th'
        end
        header |= (options.delete(:header) == true) | (options.delete(:head) == true) | (options.delete(:th) == true)
        @tag = (header || @tag == 'th') ? 'th' : 'td'
      end
    end
  end
end