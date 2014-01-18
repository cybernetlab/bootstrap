module BootstrapIt
  #
  module ViewHelpers
    #
    # Button Toolbar
    #
    # @author [alexiss]
    #
    class ButtonToolbar < WrapIt::Container
      html_class 'btn-toolbar'

      child :button_group, 'BootstrapIt::ViewHelpers::ButtonGroup'
      alias_method :group, :button_group

      after_initialize { @options[:role] = 'toolbar' }
    end

    WrapIt.register :button_toolbar, 'BootstrapIt::ViewHelpers::ButtonToolbar'
    WrapIt.register :toolbar, 'BootstrapIt::ViewHelpers::ButtonToolbar'
  end
end
