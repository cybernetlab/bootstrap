module BootstrapIt
  #
  module ViewHelpers
    #
    # Text
    #
    # @author [alexiss]
    #
    class Text < WrapIt::Base
      include WrapIt::TextContainer
      after_initialize do
        @tag ||= @helper_name == 'text' ? 'p' : @helper_name
      end
    end

    #
    # Label
    #
    # @author [alexiss]
    #
    class Label < Text
      default_tag 'span'
      html_class 'label'
      html_class_prefix 'label-'
      enum :appearence, %i[default primary success info warning danger],
           default: :default, html_class: true
    end

    #
    # Badge
    #
    # @author [alexiss]
    #
    # TODO: right-alignment
    class Badge < Text
      default_tag 'span'
      html_class 'badge'
    end

    WrapIt.register :text, 'BootstrapIt::ViewHelpers::Text'
    WrapIt.register :p, 'BootstrapIt::ViewHelpers::Text'
    WrapIt.register :span, 'BootstrapIt::ViewHelpers::Text'
    WrapIt.register :label, 'BootstrapIt::ViewHelpers::Label'
    WrapIt.register :badge, 'BootstrapIt::ViewHelpers::Badge'
  end
end
