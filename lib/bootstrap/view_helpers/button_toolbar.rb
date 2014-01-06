module Bootstrap
  module ViewHelpers
    class ButtonToolbar < Base
      html_class 'btn-toolbar'

      helper :button_group, 'Bootstrap::ViewHelpers::ButtonGroup'
      alias_method :group, :button_group

      after_initialize {@options[:role] = 'toolbar'}
    end

    register_helper :button_toolbar, 'Bootstrap::ViewHelpers::ButtonToolbar'
    register_helper :toolbar, 'Bootstrap::ViewHelpers::ButtonToolbar'
  end
end