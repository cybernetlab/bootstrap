module Bootstrap
  module ViewHelpers
  	class Form < Base
      self.helper_names = 'form'

      self.enum :kind, %i[inline horizontal]

      after_initialize do
        add_class "form-#{self.kind}" unless self.kind.nil?
        @options[:role] = 'form'
        @tag = 'form'
      end
  	end
  end
end