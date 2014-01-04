module Bootstrap
  module ViewHelpers
    module Column
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          @args.select! do |arg|
            if /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))[-_]?(?<num>\d{1,2})$/ =~ arg
              size = SIZES[size[0]]
              add_class "col-#{size}-#{num}" unless have_class? /^col-#{size}-\d{1,2}/
              false
            else
              true
            end
          end
        end
      end
      protected
      SIZES = {'x' => 'xs', 'e' => 'xs', 's' => 'sm', 'm' => 'md', 'l' => 'lg'}
    end

    module Contextual
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          skip = have_class? ENUM
          @args.select! do |arg|
            if ENUM.include?(arg)
              add_class arg unless skip
              skip = true
              false
            else
              true
            end
          end
          ENUM.each do |state|
            s = @options.delete state.to_sym
            next if s.nil? || s != true || skip
            add_class state
            skip = true
          end
        end
      end
      protected
      ENUM = %w[active success warning danger]
    end

    module Activable
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          size = @args.size
          # remove `active` args from working array
          @args.select! {|a| 'active' != a}
          # [].any? avoiding short-circuit
          add_class 'active' if [size != @args.size, @options.delete(:active) == true].any?
        end
      end
    end

    module Disableable
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          size = @args.size
          # remove `disable` args from working array
          @args.select! {|a| /^disable(d)?$/ !~ a}
          # [].any? avoiding short-circuit
          if [size != @args.size, @options.delete(:disable) == true, @options.delete(:disabled) == true].any?
            if @tag == 'button'
              @options[:disabled] = 'disabled'
            else
              add_class 'disabled'
            end
          end
        end
      end
    end

    module Sizable
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          prefix = self.class.class_prefix
          unless prefix.blank?
            re_prefix = "(#{prefix}[-_])?"
            cl_prefix = "#{prefix}-"
          else
            re_prefix = cl_prefix = ''
          end
          skip = have_class? /^#{cl_prefix}(xs|sm|lg)$/
          @args.select! do |arg|
            if /^#{re_prefix}(sm|small)$/ =~ arg
              add_class "#{cl_prefix}sm" unless skip
              skip = true
              false
            elsif /^#{re_prefix}(lg|large)$/ =~ arg
              add_class "#{cl_prefix}lg" unless skip
              skip = true
              false
            elsif /^#{re_prefix}((xs)|(extra[-_]?small))$/ =~ arg
              add_class "#{cl_prefix}xs" unless skip
              skip = true
              false
            else
              true
            end
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
        set_callback :initialize, :after do
          size = @args.size
          @args.select! {|a| 'justify' != a && 'justified' != a}
          # [].any? avoiding short-circuit
          if [size != @args.size, @options.delete(:justify) == true, @options.delete(:justified) == true].any?
            add_class [self.class.class_prefix, 'justified'].compact.join '-'
          end
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
        delegate :divider, :header, :item, to: :dropdown_menu

        set_callback :initialize, :after do
          @dropdown_menu = nil
        end
      end
    end
  end
end