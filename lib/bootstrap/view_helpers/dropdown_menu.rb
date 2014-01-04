module Bootstrap
  module ViewHelpers
    class DropdownMenu < Base
      self.helper_names = 'dropdown_menu'

      def divider
        @items << :divider
      end

      def header title
        raise ArgumentError unless title.is_a? String
        @items << title
      end

      def item *args, &block
        body = block_given? ? yield : args.shift
        raise ArgumentError unless body.is_a? String
        url = args.shift
        url = {} unless url.is_a?(String) || url.is_a?(Hash)
        options = args.shift
        options = {} unless options.is_a? Hash
        options[:role] = 'menuitem'
        options[:tabindex] = '-1'
        @items << [body, url, options]
      end

      set_callback :initialize, :after do
        @tag = 'ul'
        @options['role'] = 'menu'
        add_class 'dropdown-menu'
        @items = []
      end

      set_callback :capture, :after do
        @content = ''.html_safe
        @items.each do |item|
          if item == :divider
            @content += @view.content_tag 'li', '', class: 'divider', role: 'presentation'
          elsif item.is_a? String
            @content += @view.content_tag 'li', item, class: 'dropdown-header', role: 'presentation'
          elsif item.is_a? Array
            @content += @view.content_tag 'li', @view.link_to(*item), role: 'presentation'
          end
        end
      end
    end
  end
end