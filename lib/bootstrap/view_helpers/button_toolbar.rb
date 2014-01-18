module Bootstrap
  #
  module ViewHelpers
    #
    # Button Toolbar
    #
    # @author [alexiss]
    #
    class ButtonToolbar < WrapIt::Container
      html_class 'btn-toolbar'

      child :button_group, 'Bootstrap::ViewHelpers::ButtonGroup'
      alias_method :group, :button_group

      after_initialize { @options[:role] = 'toolbar' }
    end

    WrapIt.register :button_toolbar, 'Bootstrap::ViewHelpers::ButtonToolbar'
    WrapIt.register :toolbar, 'Bootstrap::ViewHelpers::ButtonToolbar'
  end
end
