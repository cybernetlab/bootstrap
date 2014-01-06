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
  end
end