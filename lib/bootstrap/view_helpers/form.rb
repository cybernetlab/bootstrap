module Bootstrap
  #
  module ViewHelpers
    #
    # Input
    #
    # @author [alexiss]
    #
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

      before_render do
        @options.key?(:value) || @options[:value] = @content
        @content = empty_html
      end
    end

    #
    # FormLabel
    #
    # @author [alexiss]
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
    # @author [alexiss]
    #
    class FormGroup < WrapIt::Container
      html_class 'form-group'

      child :input, 'Bootstrap::ViewHelpers::Input' do |input|
        input_args = input.instance_variable_get(:@saved_args)
        @control_size = input_args.extract!(
          Symbol, and: [SizableColumn::COLUMN_SIZE_REGEXP]
        )
        @control_place = input_args.extract!(
          Symbol, and: [PlacableColumn::COLUMN_PLACE_REGEXP]
        )
        @control_size.empty? && @control_size = @form.control_size

        label_args = input.options.delete(:label)
        unless label_args.nil?
          label_args.is_a?(Array) || label_args = [label_args]
          @label = FormLabel.new(@template, *label_args)
          if @form.kind == :horizontal && !@label.column_size_defined?
            @label.column_size = @form.label_size
          end
          unless input.options[:id].nil?
            @label.options[:label_for] = input.options[:id]
          end
        end
      end

      after_initialize do
        @form = @options.delete :form
        # @form.is_a? Form || fail(
        #   ArgumentError,
        #   'Required option `form` for `form_group` is not specified'
        # )
      end

      after_capture do
        if @form.kind == :horizontal
          input_wrapper = Base.new(@template)
          input_wrapper.extend SizableColumn
          input_wrapper.extend PlacableColumn
          input_wrapper.column_size = @control_size
          input_wrapper.column_place = @control_place
          @content = capture { input_wrapper.render(@content) }
        end
        @label.nil? || @content = capture { @label.render } + @content
      end
    end

    #
    # Form
    #
    # @author [alexiss]
    #
    class Form < WrapIt::Container
      DEFAULT_LABEL_SIZE = %i(xs2 sm2 md2 lg2)
      DEFAULT_CONTROL_SIZE = %i(xs10 sm10 md10 lg10)

      html_class_prefix 'form-'

      enum :kind, %i[inline horizontal], html_class: true

      attr_reader :label_size
      attr_reader :control_size

      def input(*args, &block)
        group = Bootstrap::ViewHelpers::FormGroup.new(@template, form: self)
        group.input(*args, &block)
      end

      after_initialize do
        @options[:role] = 'form'
        @tag = 'form'
        if kind == :horizontal
          @label_size = options.delete(:label_size) || DEFAULT_LABEL_SIZE
          @control_size = options.delete(:control_size) || DEFAULT_CONTROL_SIZE
        end
      end
    end

    WrapIt.register :form, 'Bootstrap::ViewHelpers::Form'
  end
end
