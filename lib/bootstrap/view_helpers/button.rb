module Bootstrap
  module ViewHelpers
    class Button < Base
      include Activable
      include Disableable
      include DropdownMenuWrapper

      self.helper_names = 'button'

      def icon *args, &block
        Icon.new(@view, *args, &block).render
      end

      set_callback :capture, :after do
        @content = @icon.render + @content unless @icon.nil?
        if @dropdown_menu.is_a? Base
          @content += @view.content_tag 'span', '', class: 'caret'
          add_class 'dropdown-toggle'
          set_data :toggle, 'dropdown'
        end
      end

      set_callback :render, :after do
        if @dropdown_menu.is_a? Base
          self.wrapper = {tag: 'div', class: 'btn-group'}
          @content += @dropdown_menu.render
        end
      end

      set_callback :initialize, :after do
        type = 'default'
        @icon = nil
        @args.each do |arg|
          if TYPES.include? arg
            type = arg
          elsif arg == 'block'
            add_class 'btn-block'
          else
            size = SIZES.keys.select {|re| re.match arg}.first
            add_class SIZES[size] unless size.nil?
          end
        end
        add_class ['btn', "btn-#{type}"]
        @tag = 'button' unless @tag == 'a' || @tag == 'input'
        if @tag == 'a'
          @options[:role] = "button"
        else
          @options[:type] = "button" unless @options.include? :type
          @options[:type] = @options[:type].to_s.downcase
        end
        if @options.key? :size
          s = options.delete :size
          size = SIZES.keys.select {|re| re.match s}.first
          add_class SIZES[size] unless size.nil? || @options[:class].any? {|c| SIZES.values.include? c}
        end
        if @options.key? :icon
          @icon = Icon.new @view, @options.delete(:icon)
        end
        add_class 'btn-block' if @options.delete(:block) == true
      end

      private
      TYPES = %w[default primary success info warning danger link]
      SIZES = {
        /^(btn[-_])?(sm|small)$/ => 'btn-sm',
        /^(btn[-_])?(lg|large)$/ => 'btn-lg',
        /^(btn[-_])?((xs)|(extra[-_]?small))$/ => 'btn-xs'
      }
    end
  end
end