module BootstrapIt
  #
  module ViewHelpers
    #
    # @see http://getbootstrap.com/components/#breadcrumbs Bootstrap docs
    # Breadcrumb
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class Breadcrumb < WrapIt::Container
      default_tag 'ol'
      html_class 'breadcrumb'

      child :link_item, 'BootstrapIt::ViewHelpers::ListLinkItem'
      child :item, 'BootstrapIt::ViewHelpers::ListItem'
    end

    register :breadcrumb, 'BootstrapIt::ViewHelpers::Breadcrumb'
  end
end
