module Bootstrap
  module ViewHelpers
    class Button < Base
      include Activable
      include Disableable
      include DropdownMenuWrapper
      include Sizable

      self.helper_names = ['button', 'radio', 'checkbox']
      self.class_prefix = 'btn'

      def icon *args, &block
        Icon.new(@view, *args, &block).render
      end

      set_callback :capture, :after do
        @content = @text if @text.is_a? String
        @content = @icon.render + @content unless @icon.nil?
        if @dropdown_menu.is_a? Base
          unless @splitted
            @content += @view.content_tag 'span', '', class: 'caret'
            add_class 'dropdown-toggle'
            set_data :toggle, 'dropdown'
          end
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
          if @splitted
            toggle = Base.new @view, @options.merge(tag: 'button')
            toggle.send :add_class, 'dropdown-toggle'
            toggle.send :set_data, :toggle, 'dropdown'
            @content += toggle.render(@view.content_tag('span', '', class: 'caret'))
          end
          wrapper_class = ['btn-group']
          wrapper_class << 'dropup' if @dropup
          self.wrapper = {tag: 'div', class: wrapper_class}
          @content += @dropdown_menu.render
        end
      end

      set_callback :initialize, :after do
        type = 'default'
        @text, @icon, @splitted, @dropup = nil, nil, false, false
        @args.each do |arg|
          if TYPES.include? arg
            type = arg
          elsif arg == 'block'
            add_class 'btn-block'
          elsif arg == 'toggle'
            set_data :toggle, 'button'
          elsif arg == 'splitted'
            @splitted = true
          elsif arg == 'dropup'
            @dropup = true
          else
            @text = arg.html_safe
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
        if @options.key? :icon
          @icon = Icon.new @view, @options.delete(:icon)
        end
        @splitted = true if @options.delete(:splitted) == true
        @dropup = true if @options.delete(:dropup) == true
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
    end
  end
end