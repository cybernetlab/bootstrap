module Bootstrap
  module ViewHelpers
    class Table < Base
      def render
        add_class 'table'
        add_class 'table-striped' if @striped
        add_class 'table-bordered' if @bordered
        add_class 'table-hover' if @hover
        add_class 'table-condensed' if @condensed
        html = @view.content_tag 'table', content, @options
        html = @view.content_tag 'div', html, class: 'table-responsive' if @responsive
        html
      end

      def row *args, &block
        TableRow.new(@view, *args, &block).render
      end

      def self.helper_names
        'table'
      end

      after_initialize do |*args|
        @responsive = false
        args.each do |arg|
          arg = arg.to_s.downcase
          if SWITCHERS.include? arg.to_sym
            instance_variable_set "@#{arg}".to_sym, true
          end
        end
        SWITCHERS.each do |switch|
          instance_variable_set "@#{switch}".to_sym, options.delete(switch).is_a?(TrueClass) if @options.include? switch
        end
        @bordered = true if options.delete(:border) == true
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

      after_initialize do |*args|
        @tag = 'tr'
      end
    end

    class TableCell < Base
      include Column

      def self.helper_names; nil; end

      after_initialize do |*args|
        header = false
        args.each do |arg|
          arg = arg.to_s.downcase
          header = arg == 'header' || arg == 'head' || arg == 'th'
        end
        header |= (options.delete(:header) == true) | (options.delete(:head) == true) | (options.delete(:th) == true)
        @tag = (header || @tag == 'th') ? 'th' : 'td'
      end
    end
  end
end