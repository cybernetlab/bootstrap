module BootstrapIt
  #
  module ViewHelpers
    #
    # Button
    #
    # @author [alexiss]
    #
    class Button < WrapIt::Container
      include Activable
      include Disableable
      include Sizable
      include WrapIt::TextContainer

      html_class 'btn'
      html_class_prefix 'btn-'

      switch :toggle do |value|
        value ? set_html_data(:toggle, 'button') : remove_html_data(:toggle)
      end
      switch :block, html_class: true
      enum :appearence,
           %i[default primary success info warning danger link],
           default: :default, html_class: true

      child :icon, 'BootstrapIt::ViewHelpers::Icon'

      before_render do
        unless @icon.nil?
          @content = capture { @icon.render } + html_safe(' ') + @content
        end

        if @helper_name == :radio || @helper_name == :checkbox
          @tag = 'label'
          input_options = {type: @helper_name}
          @options.each do |k, v|
            next if k == :class || k == :type
            input_options[k] = @options.delete(k)
          end
          input_options.key?(:checked) && input_options[:checked] != false &&
            input_options[:checked] = 'checked'
          @content = content_tag('input', '', input_options) + @content
          input_options[:id].blank? ||
            @options[:label_for] = input_options[:id]
        end
        true
      end

      after_capture do
        @icon.nil? && !@content.empty? && @content += html_safe(' ')
      end

      after_initialize do
        @tag = 'button' unless @tag == 'a' || @tag == 'input'
        if @tag == 'a'
          @options[:role] = 'button'
        else
          @options[:type] = 'button' unless @options.include?(:type)
          @options[:type] = @options[:type].to_s.downcase
        end

        @options.key?(:icon) &&
          @icon = Icon.new(@template, @options.delete(:icon))

        @options.keys.each do |key|
          next unless /_text$/ =~ key
          value = @options.delete(key)
          next unless value.is_a?(String)
          set_html_data(key.to_s.gsub(/_/, '-'), value)
        end
      end
    end

    #
    # DropdownButton
    #
    # @author [alexiss]
    #
    class DropdownButton < Button
      include DropdownMenuWrapper

      switch :splitted
      switch :dropup

      after_capture do
        unless @dropdown_items.empty?
          unless splitted?
            @content += content_tag('span', '', class: 'caret')
            add_html_class('dropdown-toggle')
            set_html_data(:toggle, 'dropdown')
          end
        end
      end

      after_render do
        unless @dropdown_items.empty?
          if splitted?
            toggle = WrapIt::Base.new(@template, @options.merge(tag: 'button'))
            toggle.add_html_class('dropdown-toggle')
            toggle.set_html_data(:toggle, 'dropdown')
            @content += capture do
              toggle.render(content_tag('span', '', class: 'caret'))
            end
          end
          wrapper_class = ['btn-group']
          wrapper_class << 'dropup' if dropup?
          wrap(class: wrapper_class)
        end
      end
    end

    WrapIt.register :button, :radio, :checkbox,
                    'BootstrapIt::ViewHelpers::Button'
    WrapIt.register :dropdown_button, 'BootstrapIt::ViewHelpers::DropdownButton'
  end
end
