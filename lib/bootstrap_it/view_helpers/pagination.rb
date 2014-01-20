module BootstrapIt
  #
  module ViewHelpers
    #
    # Pagination
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#pagination Bootstrap docs
    class Pagination < WrapIt::Container
      include Sizable

      default_tag 'ul'
      html_class 'pagination'

      child :link_item, ListLinkItem
    end

    #
    # Pager
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#pagination-pager Bootstrap docs
    class Pager < WrapIt::Container
      default_tag 'ul'
      html_class 'pager'
      child :link_item, ListLinkItem
      child :previous, ListLinkItem, li_class: 'previous'
      child :next, ListLinkItem, li_class: 'next'
    end

    register :pagination, 'BootstrapIt::ViewHelpers::Pagination'
    register :pager, 'BootstrapIt::ViewHelpers::Pager'
  end
end
