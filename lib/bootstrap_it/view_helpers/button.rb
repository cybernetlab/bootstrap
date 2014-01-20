module BootstrapIt
  #
  module ViewHelpers
    #
    # Button
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/css/#buttons Bootstrap docs
    # @see http://getbootstrap.com/javascript/#buttons Bootstrap docs
    class Button < WrapIt::Container
      include WrapIt::TextContainer
      include Activable
      include Disableable
      include Sizable

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
      extract_from_options icon: :icon
      section :space_separator, :input
      place :children, after: :begin
      place :space_separator, after: :children
      place :input, before: :content

      after_capture do
        children.size > 0 && self[:space_separator] = html_safe(' ')

        if @helper_name == :radio || @helper_name == :checkbox
          @tag = 'label'
          input_options = {type: @helper_name}
          @options.each do |k, v|
            next if k == :class || k == :type
            input_options[k] = @options.delete(k)
          end
          if input_options.key?(:checked) && input_options[:checked] != false
            input_options[:checked] = 'checked'
          end
          self[:input] = content_tag('input', '', input_options)
          unless input_options[:id].blank?
            @options[:label_for] = input_options[:id]
          end
        end
      end

      after_initialize do
        @tag == 'a' || @tag == 'input' || @tag = 'button'
        if @tag == 'a'
          @options[:role] = 'button'
        else
          @options.include?(:type) || @options[:type] = 'button'
          @options[:type] = @options[:type].to_s.downcase
        end

        @options.keys.each do |key|
          /_text$/ =~ key || next
          value = @options.delete(key)
          value.is_a?(String) || next
          set_html_data(key.to_s.gsub(/_/, '-'), value)
        end
      end
    end

    #
    # DropdownButton
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#btn-dropdowns Bootstrap docs
    class DropdownButton < Button
      include DropdownMenuWrapper

      switch :splitted
      switch :dropup
      section :caret, :splitted
      place :caret, after: :content
      place :splitted, after: :caret
      place :space_separator, before: :caret
      place :children, before: :end

      after_capture do
        if !@dropdown_menu.nil?
          caret = content_tag('span', empty_html, class: 'caret')
          if splitted?
            toggle = WrapIt::Base.new(@template, @options.merge(tag: 'button'))
            toggle.add_html_class('dropdown-toggle')
            toggle.set_html_data(:toggle, 'dropdown')
            self[:splitted] = capture { toggle.render(caret) }
            self[:space_separator] = empty_html
          else
            self[:caret] = caret
            self[:space_separator] = html_safe(' ')
            add_html_class('dropdown-toggle')
            set_html_data(:toggle, 'dropdown')
          end
          #puts "--- #{self.class.placement}"
          #puts "--> #{instance_variable_get(:@sections)}"
          self[:content] = render_sections(except: [:children, :splitted])
          @after_render = render_sections(:children, :splitted)
          #puts "RENDERED: #{self[:content]} #{@}"
          wrapper_class = ['btn-group']
          wrapper_class << 'dropup' if dropup?
          wrap(class: wrapper_class)
        end
      end

      after_render do
        @after_render.nil? || @rendered << @after_render
      end
    end

    register :button, :radio, :checkbox, 'BootstrapIt::ViewHelpers::Button'
    register :dropdown_button, 'BootstrapIt::ViewHelpers::DropdownButton'
  end
end
