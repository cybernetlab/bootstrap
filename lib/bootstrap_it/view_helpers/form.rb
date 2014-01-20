module BootstrapIt
  #
  module ViewHelpers
    #
    # Input
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/css/#forms Bootstrap docs
    class Input < WrapIt::Base
      include WrapIt::TextContainer
      TYPES = %w(text password datetime datetime-local date month time
                 week number email url search tel color hidden)
      html_class 'form-control'

      after_initialize do
        @tag = 'input'
        @options.key?(:type) &&
          TYPES.include?(@options[:type].to_s.downcase) ||
          @options[:type] = 'text'
        @saved_args = @arguments.clone
      end

      after_capture do
        @options.key?(:value) || @options[:value] = render_sections
      end
    end

    #
    # FormLabel
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class FormLabel < WrapIt::Base
      include WrapIt::TextContainer
      include SizableColumn
      include PlacableColumn
      default_tag 'label'
      html_class 'form-label'
    end

    #
    # FormGroup
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class FormGroup < WrapIt::Container
      html_class 'form-group'

      section :label, :input

      child :label, 'BootstrapIt::ViewHelpers::FormLabel', section: :label
      child :input, 'BootstrapIt::ViewHelpers::Input' do |input|
        input_args = input.instance_variable_get(:@saved_args)
        control_size = input_args.extract!(
          Symbol, and: [SizableColumn::COLUMN_SIZE_REGEXP]
        )
        control_place = input_args.extract!(
          Symbol, and: [PlacableColumn::COLUMN_PLACE_REGEXP]
        )
        control_size.empty? && control_size = parent.control_size

        if parent.kind == :horizontal
          input_wrapper = WrapIt::Base.new(@template)
          input_wrapper.extend SizableColumn
          input_wrapper.extend PlacableColumn
          input_wrapper.column_size = control_size
          input_wrapper.column_place = control_place
          input.wrap(input_wrapper)
        end

        args = input.options.delete(:label)
        unless args.nil?
          args.is_a?(Array) || args = [args]
          options = args.extract_options!
          unless input.options[:id].nil?
            options[:label_for] = input.options[:id]
          end
          args << options
          label(*args)
          l = children.last
          if parent.kind == :horizontal && !l.column_size_defined?
            l.column_size = @form.label_size
          end
        end
      end
    end

    #
    # Form
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/css/#forms Bootstrap docs
    class Form < WrapIt::Container
      DEFAULT_LABEL_SIZE = %i(xs2 sm2 md2 lg2)
      DEFAULT_CONTROL_SIZE = %i(xs10 sm10 md10 lg10)

      html_class_prefix 'form-'

      enum :kind, %i[inline horizontal], html_class: true

      attr_reader :label_size
      attr_reader :control_size

      child :group, 'BootstrapIt::ViewHelpers::FormGroup',
            deffered_render: true

      def input(*args, &block)
        group { |g| g.input(*args, &block) }
      end

      after_initialize do
        @options[:role] = 'form'
        @tag = 'form'
        if kind == :horizontal
          @label_size = options.delete(:label_size) || DEFAULT_LABEL_SIZE
          @control_size = options.delete(:control_size) || DEFAULT_CONTROL_SIZE
        end
        self.deffered_render = true
      end
    end

    register :form, 'BootstrapIt::ViewHelpers::Form'
  end
end
