module BootstrapIt
  #
  module ViewHelpers
    #
    # DropdownNavItem
    #
    # @author [alexiss]
    #
    class DropdownNavItem < WrapIt::Container
      include WrapIt::TextContainer
      include Activable
      include Disableable
      include DropdownMenuWrapper

      default_tag 'li'
      html_class 'dropdown'

      after_capture do
        # TODO: TextContainer should include body into content, but content
        # empty at this point
        @content += @body.html_safe unless @body.nil?
        body = @content + html_safe(' ') +
          content_tag('span', '', class: 'caret')
        # TODO: Replace 'link_to'
        @content = @template.link_to(
          body, '#', class: 'dropdown-toggle', data: {toggle: 'dropdown'}
        )
      end
    end

    #
    # Nav
    #
    # @author [alexiss]
    #
    class Nav < WrapIt::Container
      include Justifable

      html_class 'nav'
      default_tag 'ul'

      child :link_item, ListLinkItem
      child :dropdown, DropdownNavItem
    end

    #
    # NavPills
    #
    # @author [alexiss]
    #
    class NavPills < Nav
      default_tag 'ul'
      switch :stacked, html_class: 'nav-stacked'
      html_class 'nav-pills'
    end

    #
    # NavTabs
    #
    # @author [alexiss]
    #
    class NavTabs < Nav
      default_tag 'ul'
      html_class 'nav-tabs'
    end

    #
    # NavBar
    #
    # @author [alexiss]
    #
    class NavBar < WrapIt::Container
      default_tag 'nav'
      html_class 'navbar'
      html_class_prefix 'navbar-'

      enum :position, %i[fixed-top fixed-bottom static-top], html_class: true
      enum :type, %i[default inverse], default: :default, html_class: true

      after_initialize do
        @options[:role] = 'navigation'
      end

      child :button, 'BootstrapIt::ViewHelpers::Button', [class: 'navbar-btn']
      child :text, 'BootstrapIt::ViewHelpers::Text', [class: 'navbar-text']
      alias_method :p, :text
      child :span, 'BootstrapIt::ViewHelpers::Text', [class: 'navbar-text']
    end

    WrapIt.register :nav_pills, 'BootstrapIt::ViewHelpers::NavPills'
    WrapIt.register :pills, 'BootstrapIt::ViewHelpers::NavPills'
    WrapIt.register :nav_tabs, 'BootstrapIt::ViewHelpers::NavTabs'
    WrapIt.register :tabs, 'BootstrapIt::ViewHelpers::NavTabs'
    WrapIt.register :navbar, 'BootstrapIt::ViewHelpers::NavBar'
  end
end
