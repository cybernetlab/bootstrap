module Bootstrap
  module ViewHelpers
    class Button < Base
      include Activable
      include Disableable
      include DropdownMenuWrapper

      self.helper_names = ['button', 'radio', 'checkbox']

      def icon *args, &block
        Icon.new(@view, *args, &block).render
      end

      set_callback :capture, :after do
        @content = @text if @text.is_a? String
        @content = @icon.render + @content unless @icon.nil?
        if @dropdown_menu.is_a? Base
          @content += @view.content_tag 'span', '', class: 'caret'
          add_class 'dropdown-toggle'
          set_data :toggle, 'dropdown'
        end
        if @helper_name == 'radio' || @helper_name == 'checkbox'
          @tag = 'label'
          input_options = {type: @helper_name}
          @options.each {|k, v| input_options[k] = @options.delete k unless k == :class || k == :type}
          input_options[:checked] = 'checked' if input_options.key?(:checked) && input_options[:checked] != false
          @content = @view.content_tag('input', '', input_options) + @content
          @options[:label_for] = input_options[:id] unless input_options[:id].blank?
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
        @text = nil
        @icon = nil
        @args.each do |arg|
          if TYPES.include? arg
            type = arg
          elsif arg == 'block'
            add_class 'btn-block'
          else
            size = SIZES.keys.select {|re| re.match arg}.first
            if size.nil?
              if arg == 'toggle'
                set_data :toggle, 'button'
              else
                @text = arg
              end
            else
              add_class SIZES[size]
            end
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
        @text = @options.delete :text if @options[:text].is_a? String
        set_data :toggle, 'button' if options.delete(:toggle) == true
        add_class 'btn-block' if @options.delete(:block) == true

        @options.keys.each do |key|
          next unless /_text$/ =~ key
          value = @options.delete(key)
          set_data key.to_s.gsub(/_/, '-'), value if value.is_a? String
        end
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