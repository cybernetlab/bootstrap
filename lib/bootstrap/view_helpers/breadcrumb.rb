module Bootstrap
  module ViewHelpers
    class Breadcrumb < Base
      include List

      TAG = 'ol'
      html_class 'breadcrumb'

      item_type :link_item, ListLinkItem
      item_type :item, ListItem
    end

    register_helper :breadcrumb, 'Bootstrap::ViewHelpers::Breadcrumb'
  end
end