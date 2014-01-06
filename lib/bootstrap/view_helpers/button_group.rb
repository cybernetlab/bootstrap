module Bootstrap
  module ViewHelpers
    class ButtonGroup < Base
      include Sizable
      include Justifable

      self.class_prefix = 'btn-group'

      html_class 'btn-group'
      flag :vertical, html_class: 'btn-group-vertical'

      helper :button, 'Bootstrap::ViewHelpers::Button'
      helper(:radio, 'Bootstrap::ViewHelpers::Button') {|button| set_data :toggle, 'buttons'}
      helper(:checkbox, 'Bootstrap::ViewHelpers::Button') {|button| set_data :toggle, 'buttons'}
      helper :dropdown, 'Bootstrap::ViewHelpers::DropdownButton'
    end

    register_helper :button_group, 'Bootstrap::ViewHelpers::ButtonGroup'
  end
end