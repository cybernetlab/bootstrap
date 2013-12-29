module Bootstrap
  module ViewHelpers
    module Column
      extend ActiveSupport::Concern
      included do
        after_initialize do |*args|
          args.each do |arg|
            next unless arg.is_a?(String) || arg.is_a?(Symbol)
            arg = arg.to_s.downcase
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
        after_initialize do |*args|
          args.each do |arg|
            next unless arg.is_a?(String) || arg.is_a?(Symbol)
            arg = arg.to_s.downcase
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
        after_initialize do |*args|
          add_class 'active' if args.select {|a| a.is_a?(String) || a.is_a?(Symbol)}.any? {|a| 'active' == a.to_s.downcase}
          add_class 'active' if @options.delete(:active) == true
        end
      end
    end

    module Disableable
      extend ActiveSupport::Concern
      included do
        after_initialize do |*args|
          disable = args.select {|a| a.is_a?(String) || a.is_a?(Symbol)}.any? {|a| /^disable(d)?$/ =~ a.to_s.downcase}
          disable = true if @options.delete(:disable) == true || @options.delete(:disabled) == true
          if disable
            if @tag == 'button'
              @options[:disabled] = 'disabled'
            else
              add_class 'disabled'
            end
          end
        end
      end
    end
  end
end