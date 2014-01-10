module Bootstrap
  module ViewHelpers
    module Column
      extend ActiveSupport::Concern
      included do
        after_initialize do
          re = /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))[-_]?(?<num>\d{1,2})$/
          @args.extract!(Symbol, and: [re]).each do |arg|
            m = re.match arg.to_s
            size = SIZES[m[:size][0]]
            add_class "col-#{size}-#{m[:num]}" unless have_class?(/^col-#{size}-\d{1,2}/)
          end
        end
      end
      protected
      SIZES = {'x' => 'xs', 'e' => 'xs', 's' => 'sm', 'm' => 'md', 'l' => 'lg'}
    end

    module Contextual
      extend ActiveSupport::Concern
      included do
        enum :state, %i[active success warning danger]
        after_initialize {add_class self.state unless self.state.nil?}
      end
    end

    module Activable
      extend ActiveSupport::Concern
      included do
        flag :active, html_class: 'active'
      end
    end

    module Disableable
      extend ActiveSupport::Concern
      included do
        flag :disabled, aliases: [:disable] do |value|
          if value
            @tag == 'button' ? @options[:disabled] = 'disabled' : add_class('disabled')
          else
            @tag == 'button' ? @options.delete(:disabled) : remove_class('disabled')
          end
        end
      end
    end

    module Sizable
      extend ActiveSupport::Concern
      included do
        after_initialize do
          prefix = self.class.class_prefix
          unless prefix.blank?
            re_prefix = "(#{prefix}[-_])?"
            cl_prefix = "#{prefix}-"
          else
            re_prefix = cl_prefix = ''
          end
          skip = have_class?(/^#{cl_prefix}(xs|sm|lg)$/)
          unless skip || @args.extract!(Symbol, and: [/^#{re_prefix}(sm|small)$/]).empty?
            add_class "#{cl_prefix}sm"
            skip = true
          end
          unless skip || @args.extract!(Symbol, and: [/^#{re_prefix}(lg|large)$/]).empty?
            add_class "#{cl_prefix}lg"
            skip = true
          end
          unless skip || @args.extract!(Symbol, and: [/^#{re_prefix}((xs)|(extra[-_]?small))$/]).empty?
            add_class "#{cl_prefix}xs"
            skip = true
          end
          if @options.key? :size
            size = @options.delete :size
            unless skip
              case size
              when /^#{re_prefix}(sm|small)$/ then add_class "#{cl_prefix}sm"
              when /^#{re_prefix}(lg|large)$/ then add_class "#{cl_prefix}lg"
              when /^#{re_prefix}((xs)|(extra[-_]?small))$/ then add_class "#{cl_prefix}xs"
              end
            end
          end
        end
      end
    end

    module Justifable
      extend ActiveSupport::Concern
      included do
        flag :justified, aliases: [:justify]
        after_initialize do
          add_class [self.class.class_prefix, 'justified'].compact.join '-' if justified?
        end
      end
    end

    module DropdownMenuWrapper
      extend ActiveSupport::Concern

      protected
      def dropdown_menu
        @dropdown_menu ||= DropdownMenu.new @view
      end

      included do
        delegate :divider, :header, :link_item, to: :dropdown_menu
        after_initialize {@dropdown_menu = nil}
        after_render {@content += @view.capture {@dropdown_menu.render} unless @dropdown_menu.nil?}
      end
    end
  end
end