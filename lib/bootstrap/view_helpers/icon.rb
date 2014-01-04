module Bootstrap
  module ViewHelpers
    class Icon < Base
      def self.helper_names
        ['icon', 'i']
      end

      set_callback :capture, :after do
        @content = ''
      end

      set_callback :initialize, :after do
        @tag = 'i'
        @icon = @args.size < 1 ? 'asterisk' : @args[0]
        prefix = Bootstrap.config.font_awesome ? 'fa' : 'glyphicon'
        add_class [prefix, "#{prefix}-#{@icon}"]
      end
    end
  end
end