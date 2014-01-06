module Bootstrap
  module ViewHelpers
    class Icon < Base
      after_capture do
        @content = EMPTY_HTML
      end

      after_initialize do
        @tag = 'i'
        @icon = @args.size < 1 ? 'asterisk' : @args[0]
        prefix = Bootstrap.config.font_awesome ? 'fa' : 'glyphicon'
        add_class [prefix, "#{prefix}-#{@icon}"]
      end
    end

    register_helper :icon, 'Bootstrap::ViewHelpers::Icon'
  end
end