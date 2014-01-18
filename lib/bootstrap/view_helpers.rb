module Bootstrap
  #
  module ViewHelpers
#    def self.register_helper *args
#      class_name = args.pop
#      unless class_name.is_a?(String) ||
#             class_name.is_a?(Class) && class_name < Base
#        fail(
#          ArgumentError,
#          "Last argument for #{self.name}.register_helper should be" \
#          " class, derived from #{self.name}::Base or class name"
#        )
#      end
#      class_name = class_name.name if class_name.is_a? Class
#      @helpers ||= {}
#      args.each do |arg|
#        fail(
#          ArgumentError,
#          "First arguments for #{self.name}.register_helper should be " \
#          "Symbols with helper names"
#        ) unless arg.is_a?(Symbol)
#        fail(
#          ArgumentError, "Helper #{arg} for #{self.name}.register_helper" \
#          " allready exists"
#        ) if @helpers.key?(arg)
#        @helpers[arg] = class_name
#      end
#    end
#
#    def self.register_helpers #view
#      @helpers ||= {}
#      @helpers.each do |helper, class_name|
#        define_method helper do |*args, &block|
#          begin
#            options = args.last.is_a?(Hash) ? args.last : args.push({}).last
#            options[:helper_name] = helper.to_s
#            obj = class_name.constantize.new(self, *args, &block)
#            obj.render
#          rescue NameError
#            raise NameError.new "Helper class #{class_name} doesn't exists"
#          end
#        end
#      end
#    end

    def bootstrap_stylesheets
      src = Bootstrap.config.assets_source
      if src == :cdn
        stylesheet_link_tag("//netdna.bootstrapcdn.com/bootstrap/" \
          "#{Bootstrap.config.bootstrap_version}/css/bootstrap.min.css")
        if Bootstrap.config.font_awesome
          stylesheet_link_tag("//netdna.bootstrapcdn.com/font-awesome/" \
            "#{Bootstrap.config.font_awesome_version}/css/font-awesome.css")
        end
      elsif src == :precompiled
        stylesheet_link_tag('bootstrap')
        stylesheet_link_tag('font-awesome') if Bootstrap.config.font_awesome
      end
    end

    def bootstrap_javascripts
      src = Bootstrap.config.assets_source
      if src == :cdn
        javascript_include_tag("//netdna.bootstrapcdn.com/bootstrap/" \
          "#{Bootstrap.config.bootstrap_version}/js/bootstrap.min.jss")
      elsif src == :precompiled
        javascript_include_tag('bootstrap')
      end
    end

    def bootstrap_headers
      bootstrap_stylesheets
      bootstrap_javascripts
    end
  end
end

require 'bootstrap/view_helpers/mixin'
require 'bootstrap/view_helpers/icon'
require 'bootstrap/view_helpers/text'
require 'bootstrap/view_helpers/grid'
require 'bootstrap/view_helpers/table'
require 'bootstrap/view_helpers/list'
require 'bootstrap/view_helpers/dropdown_menu'
require 'bootstrap/view_helpers/button'
require 'bootstrap/view_helpers/button_group'
require 'bootstrap/view_helpers/button_toolbar'
require 'bootstrap/view_helpers/form'
require 'bootstrap/view_helpers/nav'
require 'bootstrap/view_helpers/breadcrumb'
require 'bootstrap/view_helpers/pagination'
require 'bootstrap/view_helpers/misc'
