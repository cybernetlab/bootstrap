module Bootstrap
  module ViewHelpers
    module TextContainer
      extend ActiveSupport::Concern

      TAG = 'p'

      included do
        after_initialize do
          @body = @args.extract_first!(String) || Base::EMPTY_HTML
          @body += @options[:body] || @options[:text] || Base::EMPTY_HTML
          @options.delete(:body)
          @options.delete(:text)
        end

        after_capture do
          # TODO: take care about html_safe here
          @content = @body.html_safe + @content unless @body.nil?
        end
      end
    end

    class Text < Base
      include TextContainer
      after_initialize do
        @tag ||= @helper_name == 'text' ? 'p' : @helper_name
      end
    end

    class Link < Base
      include TextContainer
      TAG = 'a'
    end

    class Label < Text
      TAG = 'span'
      html_class 'label'
      enum :appearence, %i[default primary success info warning danger]
      after_initialize do
        self.appearence ||= :default
        add_class "label-#{self.appearence}"
      end
    end

    # TODO: right-alignment
    class Badge < Text
      TAG = 'span'
      html_class 'badge'
    end

    register_helper :text, 'Bootstrap::ViewHelpers::Text'
    register_helper :p, 'Bootstrap::ViewHelpers::Text'
    register_helper :span, 'Bootstrap::ViewHelpers::Text'
    register_helper :label, 'Bootstrap::ViewHelpers::Label'
    register_helper :badge, 'Bootstrap::ViewHelpers::Badge'
  end
end