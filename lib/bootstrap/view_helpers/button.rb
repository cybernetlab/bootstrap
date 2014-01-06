module Bootstrap
  module ViewHelpers
    class Button < Base
      include Activable
      include Disableable
      include Sizable
      include TextContainer

      self.class_prefix = 'btn'
      html_class 'btn'

      flag(:toggle) {|value| value ? set_data(:toggle, 'button') : unset_data(:toggle)}
      flag :block, html_class: 'btn-block'
      enum :fashion, %i[default primary success info warning danger link]

      helper :icon, 'Bootstrap::ViewHelpers::Icon'

      after_capture do
        @content = @icon.render + @content unless @icon.nil?
        if @helper_name == 'radio' || @helper_name == 'checkbox'
          @tag = 'label'
          input_options = {type: @helper_name}
          @options.each {|k, v| input_options[k] = @options.delete k unless k == :class || k == :type}
          input_options[:checked] = 'checked' if input_options.key?(:checked) && input_options[:checked] != false
          @content = @view.content_tag('input', '', input_options) + @content
          @options[:label_for] = input_options[:id] unless input_options[:id].blank?
        end
      end

      after_initialize do
        @tag = 'button' unless @tag == 'a' || @tag == 'input'
        if @tag == 'a'
          @options[:role] = "button"
        else
          @options[:type] = "button" unless @options.include? :type
          @options[:type] = @options[:type].to_s.downcase
        end

        @icon = @options.key?(:icon) ? Icon.new(@view, @options.delete(:icon)) : nil

        self.fashion ||= :default
        add_class "btn-#{self.fashion}"

        @options.keys.each do |key|
          next unless /_text$/ =~ key
          value = @options.delete(key)
          set_data key.to_s.gsub(/_/, '-'), value if value.is_a? String
        end
      end
    end

    class DropdownButton < Button
      include DropdownMenuWrapper

      self.flag :splitted
      self.flag :dropup

      after_capture do
        if @dropdown_menu.is_a? Base
          unless splitted?
            @content += @view.content_tag 'span', '', class: 'caret'
            add_class 'dropdown-toggle'
            set_data :toggle, 'dropdown'
          end
        end
      end

      after_render do
        if @dropdown_menu.is_a? Base
          if splitted?
            toggle = Base.new @view, @options.merge(tag: 'button')
            toggle.send :add_class, 'dropdown-toggle'
            toggle.send :set_data, :toggle, 'dropdown'
            @content += toggle.render(@view.content_tag('span', '', class: 'caret'))
          end
          wrapper_class = ['btn-group']
          wrapper_class << 'dropup' if dropup?
          self.wrapper = {tag: 'div', class: wrapper_class}
        end
      end
    end

    register_helper :button, :radio, :checkbox, 'Bootstrap::ViewHelpers::Button'
    register_helper :dropdown_button, 'Bootstrap::ViewHelpers::DropdownButton'
  end
end