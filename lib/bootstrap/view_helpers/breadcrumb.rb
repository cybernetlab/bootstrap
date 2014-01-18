module Bootstrap
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

      child :link_item, 'Bootstrap::ViewHelpers::ListLinkItem'
      child :item, 'Bootstrap::ViewHelpers::ListItem'
    end

    WrapIt.register :breadcrumb, 'Bootstrap::ViewHelpers::Breadcrumb'
  end
end
