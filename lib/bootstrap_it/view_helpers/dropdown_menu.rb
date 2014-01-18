module BootstrapIt
  #
  module ViewHelpers
    #
    # Dropdown Menu
    #
    # @author [alexiss]
    #
    class DropdownMenu < WrapIt::Container
      default_tag 'ul'
      html_class 'dropdown-menu'

      child :divider, ListItem,
            [tag: 'li', class: 'divider', role: 'presentation']
      child :header, ListItem,
            [tag: 'li', class: 'dropdown-header', role: 'presentation']
      child :link_item, ListLinkItem,
            [li_role: 'presentation', role: 'menuitem', tabindex: '-1']

      after_initialize do
        @options['role'] = 'menu'
        if @options.delete(:align).to_s.downcase == 'right'
          add_html_class('pull-right')
        end
      end
    end

    WrapIt.register :dropdown_menu, 'BootstrapIt::ViewHelpers::DropdownMenu'
  end
end
