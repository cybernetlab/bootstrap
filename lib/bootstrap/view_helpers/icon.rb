module Bootstrap
  module ViewHelpers
    class Icon < Base
      def content &block; ''; end

      def self.helper_names
        ['icon', 'i']
      end

      after_initialize do |*args|
        @tag = 'i'
        @icon = args.size < 1 ? 'asterisk' : args[0].to_s
        prefix = Bootstrap.config.font_awesome ? 'fa' : 'glyphicon'
        add_class [prefix, "#{prefix}-#{@icon}"]
      end
    end
  end
end