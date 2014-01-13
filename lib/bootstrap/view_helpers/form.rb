module Bootstrap
  module ViewHelpers
    class Input < Base
      include TextContainer
      TYPES = %w[text password datetime datetime-local date month time week number email url search tel color hidden]
      html_class 'form-control'

      after_initialize do
        @tag = 'input'
        @options[:type] = 'text' unless @options.key?(:type) && TYPES.include?(@options[:type].to_s.downcase)
      end

      before_render do
        @options[:value] = @content unless @options.key? :value
        @content = Base::EMPTY_HTML
      end
    end

    class FormLabel < Base
      include TextContainer
      include SizableColumn
      include PlacableColumn
      TAG = 'label'
      html_class 'form-label'
    end

    class FormGroup < Base
      html_class 'form-group'

      helper :input, 'Bootstrap::ViewHelpers::Input' do |input|
        input_args = input.instance_variable_get(:@args)
        @control_size = input_args.extract!(Symbol, and: [SizableColumn::COLUMN_SIZE_REGEXP])
        @control_place = input_args.extract!(Symbol, and: [PlacableColumn::COLUMN_PLACE_REGEXP])
        @control_size = @form.control_size if @control_size.empty?

        label_args = input.options.delete :label
        unless label_args.nil?
          label_args = [label_args] unless label_args.is_a? Array
          @label = FormLabel.new @view, *label_args
          @label.column_size = @form.label_size if @form.kind == :horizontal && !@label.column_size_defined?
          @label.options[:label_for] = input.options[:id] unless input.options[:id].nil?
        end
      end

      after_initialize do
        @form = @options.delete :form
        raise ArgumentError.new 'Required option `form` for `form_group` is not specified' unless @form.is_a? Form
      end

      after_capture do
        if @form.kind == :horizontal
          input_wrapper = Base.new @view
          input_wrapper.extend SizableColumn
          input_wrapper.extend PlacableColumn
          input_wrapper.column_size = @control_size
          input_wrapper.column_place = @control_place
          @content = @view.capture {input_wrapper.render @content}
        end
        unless @label.nil?
          @content = @view.capture {@label.render} + @content
        end
      end
    end

  	class Form < Base
      DEFAULT_LABEL_SIZE = %i[xs2 sm2 md2 lg2]
      DEFAULT_CONTROL_SIZE = %i[xs10 sm10 md10 lg10]

      self.enum :kind, %i[inline horizontal]

      attr_reader :label_size
      attr_reader :control_size

      def input *args
        group = FormGroup.new(@view, form: self) {|g| g.input(*args)}
        group.render
      end

      after_initialize do
        add_class "form-#{self.kind}" unless self.kind.nil?
        @options[:role] = 'form'
        @tag = 'form'
        if self.kind == :horizontal
          @label_size = options.delete(:label_size) || DEFAULT_LABEL_SIZE
          @control_size = options.delete(:control_size) || DEFAULT_CONTROL_SIZE
        end
      end
  	end

    register_helper :form, 'Bootstrap::ViewHelpers::Form'
  end
end