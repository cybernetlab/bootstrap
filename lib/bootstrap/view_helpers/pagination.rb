module Bootstrap
  #
  module ViewHelpers
    #
    # Pagination
    #
    # @author [alexiss]
    #
    class Pagination < WrapIt::Container
      include Sizable

      default_tag 'ul'
      html_class 'pagination'

      child :link_item, ListLinkItem
    end

    #
    # Pager
    #
    # @author [alexiss]
    #
    class Pager < WrapIt::Container
      default_tag 'ul'
      html_class 'pager'
      child :link_item, ListLinkItem
      child :previous, ListLinkItem, [li_class: 'previous']
      child :next, ListLinkItem, [li_class: 'next']
    end

    WrapIt.register :pagination, 'Bootstrap::ViewHelpers::Pagination'
    WrapIt.register :pager, 'Bootstrap::ViewHelpers::Pager'
  end
end
