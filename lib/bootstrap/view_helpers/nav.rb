module Bootstrap
  module ViewHelpers
    class DropdownNavItem < Base
      include Activable
      include Disableable
      include DropdownMenuWrapper
      include TextContainer

      TAG = 'li'
      html_class 'dropdown'

      after_capture do
        # TODO: TextContainer should include body into content, but content empty at this point
        @content += @body.html_safe unless @body.nil?
        body = @content + ' '.html_safe + @view.content_tag('span', '', class: 'caret')
        @content = @view.link_to body, '#', class: 'dropdown-toggle', data: {toggle: 'dropdown'}
      end
    end

    class Nav < Base
      include Justifable
      include List

      html_class 'nav'

      item_type :item, ListLinkItem
      item_type :dropdown, DropdownNavItem
    end

    class NavPills < Nav
      flag :stacked, html_class: 'nav-stacked'
      html_class 'nav-pills'
    end

    class NavTabs < Nav
      html_class 'nav-tabs'
    end

    class NavBar < Base
      TAG = 'nav'
      html_class 'navbar'

      self.enum :position, %i[fixed_top fixed_bottom static_top]
      self.enum :type, %i[default inverse]

      after_initialize do
        self.type ||= :default
        @options[:role] = 'navigation'
        add_class "navbar-#{self.type}"
        add_class "navbar-#{self.position.to_s.gsub(/_/, '-')}" unless self.position.nil?
      end

      helper(:button, 'Bootstrap::ViewHelpers::Button') {|button| button.add_class('navbar-btn')}
      helper(:text, 'Bootstrap::ViewHelpers::Text') {|text| text.add_class('navbar-text')}
      alias_method :p, :text
      helper(:span, 'Bootstrap::ViewHelpers::Text') {|text| text.add_class('navbar-text')}
    end

    register_helper :nav_pills, 'Bootstrap::ViewHelpers::NavPills'
    register_helper :pills, 'Bootstrap::ViewHelpers::NavPills'
    register_helper :nav_tabs, 'Bootstrap::ViewHelpers::NavTabs'
    register_helper :tabs, 'Bootstrap::ViewHelpers::NavTabs'
    register_helper :navbar, 'Bootstrap::ViewHelpers::NavBar'
  end
end