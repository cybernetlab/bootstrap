module Bootstrap
  module ViewHelpers
    class ButtonToolbar < Base
      self.helper_names = ['toolbar', 'button_toolbar']

      def button_group *args, &block
        ButtonGroup.new(@view, *args, &block).render
      end
      alias_method :group, :button_group

      set_callback :initialize, :after do
        add_class 'btn-toolbar'
        @options[:role] = 'toolbar'
      end
    end
  end
end