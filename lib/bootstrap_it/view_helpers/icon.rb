module BootstrapIt
  #
  module ViewHelpers
    #
    # Icon
    #
    # @author [alexiss]
    #
    class Icon < WrapIt::Base
      omit_content

      after_initialize do
        @tag = 'i'
        @icon = @arguments.extract_first!(Symbol, String)
        @icon.nil? && @icon = 'asterisk'
        @icon = @icon.to_s
        prefix = BootstrapIt.config.font_awesome ? 'fa' : 'glyphicon'
        add_html_class [prefix, "#{prefix}-#{@icon}"]
      end
    end

    WrapIt.register :icon, 'BootstrapIt::ViewHelpers::Icon'
  end
end
