module Bootstrap
  module ViewHelpers
    class DropdownMenu < Base
      include List

      TAG = 'ul'
      html_class 'dropdown-menu'

      item_type :divider do |item, *args|
        item.add_class 'divider'
        options = item.instance_variable_get(:@options)
        options[:role] = 'presentation'
      end

      item_type :header do |item, *args|
        item.add_class 'dropdown-header'
        options = item.instance_variable_get(:@options)
        options[:role] = 'presentation'
      end

      item_type :item, ListLinkItem do |item, *args|
        options = item.instance_variable_get(:@options)
        link_options = item.instance_variable_get(:@link_options)
        options[:role] = 'presentation'
        link_options[:role] = 'menuitem'
        link_options[:tabindex] = '-1'
      end

      after_initialize do
        @options['role'] = 'menu'
        add_class 'pull-right' if @options.delete(:align).to_s.downcase == 'right'
      end
    end

    register_helper :dropdown_menu, 'Bootstrap::ViewHelpers::DropdownMenu'
  end
end