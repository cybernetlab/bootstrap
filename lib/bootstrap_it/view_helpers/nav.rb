module BootstrapIt
  #
  module ViewHelpers
    #
    # DropdownNavItem
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class DropdownNavItem < WrapIt::Container
      include WrapIt::TextContainer
      include Activable
      include Disableable
      include DropdownMenuWrapper

      default_tag 'li'
      html_class 'dropdown'
      place :children, before: :end

      after_capture do
        rendered = render_sections(except: :children)
        rendered << html_safe(' ') << content_tag('span', '', class: 'caret')
        self[:content] = @template.content_tag(
          'a', rendered, href: '#', class: 'dropdown-toggle',
          data: {toggle: 'dropdown'}
        )
      end
    end

    #
    # Nav
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#nav Bootstrap docs
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
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#nav-pills Bootstrap docs
    class NavPills < Nav
      default_tag 'ul'
      switch :stacked, html_class: 'nav-stacked'
      html_class 'nav-pills'
    end

    #
    # NavTabs
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#nav-tabs Bootstrap docs
    class NavTabs < Nav
      default_tag 'ul'
      html_class 'nav-tabs'
    end

    #
    # NavBar
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#navbar Bootstrap docs
    class NavBar < WrapIt::Container
      default_tag 'nav'
      html_class 'navbar'
      html_class_prefix 'navbar-'

      enum :position, %i[fixed-top fixed-bottom static-top], html_class: true
      enum :type, %i[default inverse], default: :default, html_class: true

      after_initialize do
        @options[:role] = 'navigation'
      end

      child :button, 'BootstrapIt::ViewHelpers::Button', class: 'navbar-btn'
      child :text, 'BootstrapIt::ViewHelpers::Text', class: 'navbar-text'
      alias_method :p, :text
      child :span, 'BootstrapIt::ViewHelpers::Text', class: 'navbar-text'
    end

    register :nav_pills, 'BootstrapIt::ViewHelpers::NavPills'
    register :pills, 'BootstrapIt::ViewHelpers::NavPills'
    register :nav_tabs, 'BootstrapIt::ViewHelpers::NavTabs'
    register :tabs, 'BootstrapIt::ViewHelpers::NavTabs'
    register :navbar, 'BootstrapIt::ViewHelpers::NavBar'
  end
end
