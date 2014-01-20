module BootstrapIt
  #
  module ViewHelpers
    #
    # ButtonGroup
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#btn-groups Bootstrap docs
    class ButtonGroup < WrapIt::Container
      include Sizable
      include Justifable

      html_class 'btn-group'
      html_class_prefix 'btn-group-'

      switch :vertical, html_class: true

      child :button, 'BootstrapIt::ViewHelpers::Button'
      child :dropdown, 'BootstrapIt::ViewHelpers::DropdownButton'

      child :radio, 'BootstrapIt::ViewHelpers::Button' do |_|
        set_html_data(:toggle, 'buttons')
      end

      child :checkbox, 'BootstrapIt::ViewHelpers::Button' do |_|
        set_html_data(:toggle, 'buttons')
      end
    end

    #
    # Button Toolbar
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#btn-groups-toolbar Bootstrap
    #   docs
    class ButtonToolbar < WrapIt::Container
      html_class 'btn-toolbar'

      child :button_group, 'BootstrapIt::ViewHelpers::ButtonGroup'
      alias_method :group, :button_group

      after_initialize { @options[:role] = 'toolbar' }
    end

    register :button_group, 'BootstrapIt::ViewHelpers::ButtonGroup'
    register :button_toolbar, 'BootstrapIt::ViewHelpers::ButtonToolbar'
    register :toolbar, 'BootstrapIt::ViewHelpers::ButtonToolbar'
  end
end
