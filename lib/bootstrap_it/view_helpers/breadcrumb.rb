module BootstrapIt
  #
  module ViewHelpers
    #
    # Breadcrumb
    #
    # @author [alexiss]
    #
    class Breadcrumb < WrapIt::Container
      default_tag 'ol'
      html_class 'breadcrumb'

      child :link_item, 'BootstrapIt::ViewHelpers::ListLinkItem'
      child :item, 'BootstrapIt::ViewHelpers::ListItem'
    end

    WrapIt.register :breadcrumb, 'BootstrapIt::ViewHelpers::Breadcrumb'
  end
end
