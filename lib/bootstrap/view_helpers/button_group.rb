module Bootstrap
  module ViewHelpers
    class ButtonGroup < Base
      self.helper_names = 'button_group'

      def button *args, &block
        Button.new(@view, *args, &block).render
      end

      def radio *args, &block
        args.push({}) unless args.last.is_a? Hash
        args.last[:helper_name] = 'radio'
        set_data :toggle, 'buttons'
        Button.new(@view, *args, &block).render
      end

      def checkbox *args, &block
        args.push({}) unless args.last.is_a? Hash
        args.last[:helper_name] = 'checkbox'
        set_data :toggle, 'buttons'
        Button.new(@view, *args, &block).render
      end

      set_callback :initialize, :after do
        @tag ||= 'div'
        add_class 'btn-group'
      end
    end
  end
end