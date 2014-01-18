module Bootstrap
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

      child :button, 'Bootstrap::ViewHelpers::Button'
      child :dropdown, 'Bootstrap::ViewHelpers::DropdownButton'

      child :radio, 'Bootstrap::ViewHelpers::Button' do |button|
        set_html_data(:toggle, 'buttons')
      end

      child :checkbox, 'Bootstrap::ViewHelpers::Button' do |button|
        set_html_data(:toggle, 'buttons')
      end
    end

    WrapIt.register :button_group, 'Bootstrap::ViewHelpers::ButtonGroup'
  end
end
