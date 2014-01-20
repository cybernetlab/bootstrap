module BootstrapIt
  #
  module ViewHelpers
    #
    # Text
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
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
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#labels Bootstrap docs
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
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#badges Bootstrap docs
    # TODO: right-alignment
    class Badge < Text
      default_tag 'span'
      html_class 'badge'
    end

    register :text, 'BootstrapIt::ViewHelpers::Text'
    register :p, 'BootstrapIt::ViewHelpers::Text'
    register :span, 'BootstrapIt::ViewHelpers::Text'
    register :label, 'BootstrapIt::ViewHelpers::Label'
    register :badge, 'BootstrapIt::ViewHelpers::Badge'
  end
end
