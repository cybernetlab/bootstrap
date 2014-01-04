module Bootstrap
  module ViewHelpers
  	class Form < Base
      self.helper_names = 'form'

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