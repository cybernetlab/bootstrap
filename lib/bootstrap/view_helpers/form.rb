module Bootstrap
  module ViewHelpers
  	class Form < Base
      self.enum :kind, %i[inline horizontal]

      after_initialize do
        add_class "form-#{self.kind}" unless self.kind.nil?
        @options[:role] = 'form'
        @tag = 'form'
      end
  	end

    register_helper :form, 'Bootstrap::ViewHelpers::Form'
  end
end