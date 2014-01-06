module Bootstrap
  module ViewHelpers
    class Pagination < Base
      include List
      include Sizable

      TAG = 'ul'
      html_class 'pagination'

      item_type :link_item, ListLinkItem
    end

    class Pager < Base
      include List
      TAG = 'ul'
      html_class 'pager'
      item_type :link_item, ListLinkItem
      item_type(:previous, ListLinkItem) {|item| item.add_class 'previous'}
      item_type(:next, ListLinkItem) {|item| item.add_class 'next'}
    end

    register_helper :pagination, 'Bootstrap::ViewHelpers::Pagination'
    register_helper :pager, 'Bootstrap::ViewHelpers::Pager'
  end
end