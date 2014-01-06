module Bootstrap
  module ViewHelpers
    class NavItem < ListItem
      include Activable
      include Disableable
    end

    class DropdownNavItem < Base
      include Activable
      include Disableable
      include DropdownMenuWrapper

      TAG = 'li'

      after_initialize do
        add_class 'dropdown'
        @body = @args.extract_first! String
      end

      after_capture do
        @content += @body unless @body.nil?
        body = @content + ' '.html_safe + @view.content_tag('span', '', class: 'caret')
        @content = @view.link_to body, '#', class: 'dropdown-toggle', data: {toggle: 'dropdown'}
      end
    end

    class Nav < Base
      include Justifable
      include List

      item_type :item, NavItem
      item_type :dropdown, DropdownNavItem

      after_initialize do
        add_class 'nav'
      end
    end

    class NavPills < Nav
      self.helper_names = ['nav_pills', 'pills']
      after_initialize {add_class 'nav-pills'}
    end

    class NavTabs < Nav
      self.helper_names = ['nav_tabs', 'tabs']
      after_initialize {add_class 'nav-tabs'}
    end

    class NavBar < Base
      TAG = 'nav'

      self.helper_names = ['navbar']
      self.enum :position, %i[fixed_top fixed_bottom static_top]
      self.enum :type, %i[default inverse]

      after_initialize do
        self.type ||= :default
        add_class 'navbar'
        @options[:role] = 'navigation'
        add_class "navbar-#{self.type}"
        add_class "navbar-#{self.position.to_s.gsub(/_/, '-')}" unless self.position.nil?
      end

      def button *args, &block
        Button.new(@view, *args, &block).add_class('navbar-btn').render
      end

      def text *args, &block
        options = args.last.is_a?(Hash) ? args.last : args.push({}).last
        options[:tag] ||= 'p'
        Base.new(@view, *args, &block).add_class('navbar-text').render args.shift
      end
    end
  end
end