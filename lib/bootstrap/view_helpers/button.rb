module Bootstrap
  module ViewHelpers
    class Button < Base
      include Activable
      include Disableable

      def render
        @view.content_tag @tag, capture, @options
      end

      def self.helper_names
        'button'
      end

      after_initialize do |*args|
        type = 'default'
        args.each do |arg|
          next unless arg.is_a?(String) || arg.is_a?(Symbol)
          arg = arg.to_s.downcase
          if TYPES.include? arg
            type = arg
          elsif arg == 'block'
            add_class 'btn-block'
          else
            size = SIZES.keys.select {|re| re.match arg}.first
            add_class SIZES[size] unless size.nil?
          end
        end
        add_class ['btn', "btn-#{type}"]
        @tag = 'button' unless @tag == 'a' || @tag == 'input'
        if @tag == 'a'
          @options[:role] = "button"
        else
          @options[:type] = "button" unless @options.include? :type
          @options[:type] = @options[:type].to_s.downcase
        end
        if @options.key? :size
          s = options.delete :size
          size = SIZES.keys.select {|re| re.match s}.first
          add_class SIZES[size] unless size.nil? || @options[:class].any? {|c| SIZES.values.include? c}
        end
        add_class 'btn-block' if @options.delete(:block) == true
      end

      private
      TYPES = %w[default primary success info warning danger link]
      SIZES = {
        /^(btn[-_])?(sm|small)$/ => 'btn-sm',
        /^(btn[-_])?(lg|large)$/ => 'btn-lg',
        /^(btn[-_])?((xs)|(extra[-_]?small))$/ => 'btn-xs'
      }
    end
  end
end