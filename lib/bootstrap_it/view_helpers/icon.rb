module BootstrapIt
  #
  module ViewHelpers
    #
    # Icon
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#glyphicons Bootstrap docs
    # @see http://fontawesome.io/icons/ Font awesome icon list
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

    register :icon, 'BootstrapIt::ViewHelpers::Icon'
  end
end
