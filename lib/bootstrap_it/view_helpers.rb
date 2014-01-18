module BootstrapIt
  #
  module LayoutHelpers
    def bootstrap_it_stylesheets
      src = BootstrapIt.config.assets_source
      css = ''.html_safe
      if src == :cdn
        css << stylesheet_link_tag("//netdna.bootstrapcdn.com/bootstrap/" \
          "#{BootstrapIt.config.bootstrap_version}/css/bootstrap.min.css")
        if BootstrapIt.config.font_awesome
          css << stylesheet_link_tag("//netdna.bootstrapcdn.com/font-awesome/"\
            "#{BootstrapIt.config.font_awesome_version}/css/font-awesome.css")
        end
      elsif src == :precompiled
        css << stylesheet_link_tag('bootstrap')
        if BootstrapIt.config.font_awesome
          css << stylesheet_link_tag('font-awesome')
        end
      end
      css
    end

    def bootstrap_it_javascripts
      src = BootstrapIt.config.assets_source
      css = ''.html_safe
      if src == :cdn
        css << javascript_include_tag("//netdna.bootstrapcdn.com/bootstrap/" \
          "#{BootstrapIt.config.bootstrap_version}/js/bootstrap.min.js")
      elsif src == :precompiled
        css << javascript_include_tag('bootstrap')
      end
      css
    end

    def bootstrap_it
      bootstrap_it_stylesheets << bootstrap_it_javascripts
    end
  end
end

require 'bootstrap_it/view_helpers/mixin'
require 'bootstrap_it/view_helpers/icon'
require 'bootstrap_it/view_helpers/text'
require 'bootstrap_it/view_helpers/grid'
require 'bootstrap_it/view_helpers/table'
require 'bootstrap_it/view_helpers/list'
require 'bootstrap_it/view_helpers/dropdown_menu'
require 'bootstrap_it/view_helpers/button'
require 'bootstrap_it/view_helpers/button_group'
require 'bootstrap_it/view_helpers/button_toolbar'
require 'bootstrap_it/view_helpers/form'
require 'bootstrap_it/view_helpers/nav'
require 'bootstrap_it/view_helpers/breadcrumb'
require 'bootstrap_it/view_helpers/pagination'
require 'bootstrap_it/view_helpers/misc'
