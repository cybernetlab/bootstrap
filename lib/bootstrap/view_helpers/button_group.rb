module Bootstrap
  module ViewHelpers
    class ButtonGroup < Base
      include Sizable
      include Justifable

      self.helper_names = 'button_group'
      self.class_prefix = 'btn-group'

      self.flag :vertical

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

      after_initialize do
        add_class 'btn-group'
        add_class 'btn-group-vertical' if vertical?
      end
    end
  end
end