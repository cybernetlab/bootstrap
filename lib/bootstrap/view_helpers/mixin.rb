module Bootstrap
  module ViewHelpers
    module Column
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          @args.each do |arg|
            next unless /^(?:col[-_]?)?(?<size>(?:xs|(?:extra[-_]?small))|(?:sm|small)|(?:md|medium)|(?:lg|large))[-_]?(?<num>\d{1,2})$/ =~ arg
            size = SIZES[size[0]]
            add_class "col-#{size}-#{num}" unless @options[:class].any? {|c| /^col-#{size}-\d{1,2}/ =~ c}
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
          @args.each do |arg|
            add_class arg if ENUM.include?(arg) && @options[:class].none? {|c| ENUM.include? c}
          end
          skip = @options[:class].any? {|c| ENUM.include? c}
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
          # [].any? avoiding short-circuit
          add_class 'active' if [@args.any? {|a| 'active' == a}, @options.delete(:active) == true].any?
        end
      end
    end

    module Disableable
      extend ActiveSupport::Concern
      included do
        set_callback :initialize, :after do
          # [].any? avoiding short-circuit
          if [@args.any? {|a| /^disable(d)?$/ =~ a}, @options.delete(:disable) == true, @options.delete(:disabled) == true].any?
            if @tag == 'button'
              @options[:disabled] = 'disabled'
            else
              add_class 'disabled'
            end
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