module BootstrapIt
  #
  module ViewHelpers
    #
    # ButtonGroup
    #
    # @author [alexiss]
    #
    class ButtonGroup < WrapIt::Container
      include Sizable
      include Justifable

      html_class 'btn-group'
      html_class_prefix 'btn-group-'

      switch :vertical, html_class: true

      child :button, 'BootstrapIt::ViewHelpers::Button'
      child :dropdown, 'BootstrapIt::ViewHelpers::DropdownButton'

      child :radio, 'BootstrapIt::ViewHelpers::Button' do |button|
        set_html_data(:toggle, 'buttons')
      end

      child :checkbox, 'BootstrapIt::ViewHelpers::Button' do |button|
        set_html_data(:toggle, 'buttons')
      end
    end

    WrapIt.register :button_group, 'BootstrapIt::ViewHelpers::ButtonGroup'
  end
end
