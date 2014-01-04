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
        disabled = false
        args.select! do |arg|
          if arg.is_a?(String) || arg.is_a?(Symbol)
            arg = arg.to_s.downcase
            if arg == 'disabled'
              disabled = true
              false
            else
              true
            end
          else
            true
          end
        end
        body = block_given? ? yield : args.shift
        raise ArgumentError unless body.is_a? String
        url = args.shift
        url = {} unless url.is_a?(String) || url.is_a?(Hash)
        disabled = true if url.is_a?(Hash) && url.delete(:disabled) == true
        options = args.shift
        options = {} unless options.is_a? Hash
        options[:role] = 'menuitem'
        options[:tabindex] = '-1'
        options[:disabled] = disabled
        @items << [body, url, options]
      end

      set_callback :initialize, :after do
        @tag = 'ul'
        @options['role'] = 'menu'
        add_class 'dropdown-menu'
        add_class 'pull-right' if @options.delete(:align).to_s.downcase == 'right'
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
            li_options = {role: 'presentation'}
            li_options[:class] = 'disabled' if item[2].delete(:disabled) == true
            @content += @view.content_tag 'li', @view.link_to(*item), li_options
          end
        end
      end
    end
  end
end