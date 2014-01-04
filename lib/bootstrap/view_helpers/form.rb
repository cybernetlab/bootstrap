module Bootstrap
  module ViewHelpers
  	class Form < Base
      #def row *args, &block
      #  GridRow.new(@view, *args, &block).render
      #end

      def self.helper_names
        'form'
      end

      set_callback :initialize, :after do
        @args.each do |arg|
          next unless TYPES.include? arg
          add_class "form-#{arg}"
          break
        end
        @options[:role] = 'form'
        @tag = 'form'
      end

      protected
      TYPES = %w[inline horizontal]
  	end
  end
end