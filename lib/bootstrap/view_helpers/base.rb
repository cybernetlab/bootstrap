module Bootstrap
  module ViewHelpers
    class Base
      include ActiveSupport::Callbacks

      define_callbacks :initialize
      define_callbacks :capture, terminator: 'result == false'
      define_callbacks :render, terminator: 'result == false'

      attr_accessor :tag

      def initialize view, *args, &block
        raise ArgumentError if view.nil? || !view.respond_to?(:capture)
        @view, @args, @block, @wrapper = view, args, block, nil

        run_callbacks :initialize do
          options = {tag: self.class.const_defined?(:TAG) ? self.class.const_get(:TAG) : 'div'}
          options.merge! @args.pop.symbolize_keys if @args.last.is_a? Hash

          @tag = options.delete(:tag).to_s.downcase
          self.options = options

          @args = @args.select {|a| a.is_a?(String) || a.is_a?(Symbol)}.map {|a| a.to_s.downcase}
          @helper_name = options.delete(:helper_name) || self.class.helper_names
          @helper_name = @helper_name[0] if @helper_name.is_a?(Array) && @helper_name.size > 0
        end
      end

      def render *args
        capture
        args.flatten.each {|a| @content += a if a.is_a? String}
        @content += yield self if block_given?
        run_callbacks :render do
          @content = @view.content_tag @tag, @content, @options
        end
        @content = @wrapper.render @content.html_safe if @wrapper.is_a? Base
        @content
      end

      attr_reader :options

      def have_class? value = nil, &block
        if value.is_a? Regexp
          @options[:class].any? {|c| value.match c}
        elsif value.is_a? String
          @options[:class].any? {|c| value == c}
        elsif value.is_a? Array
          @options[:class].any? {|c| value.include? c}
        elsif block_given?
          @options[:class].any? &block
        else
          false
        end
      end

      def have_no_class? value = nil, &block
        if value.is_a? Regexp
          @options[:class].none? {|c| value.match c}
        elsif value.is_a? String
          @options[:class].none? {|c| value == c}
        elsif value.is_a? Array
          @options[:class].none? {|c| value.include? c}
        elsif block_given?
          @options[:class].none? &block
        else
          false
        end
      end

      def self.helper_names
        instance_variable_defined?(:@helper_names) ? @helper_names : nil
      end

      def self.class_prefix
        ([self] + ancestors).each {|c| return c.instance_variable_get :@class_prefix if c.instance_variable_defined?(:@class_prefix)}
        nil
      end

      protected
      def self.helper_names= value
        @helper_names = value.is_a?(Array) ? value.flatten : value
      end

      def self.class_prefix= value
        @class_prefix = value.to_s
      end

      def options= hash
        return unless hash.is_a? Hash
        hash.symbolize_keys!

        # sanitize class
        hash[:class] ||= []
        hash[:class] = [hash[:class]] unless hash[:class].is_a? Array
        hash[:class] = hash[:class].map {|c| c.to_s}.uniq
        @options = hash
      end

      def add_class value
        if value.is_a? Array
          @options[:class] += value.flatten.map {|v| v.to_s}
        else
          @options[:class].push(value.to_s)
        end
        @options[:class].uniq!
      end

      def set_data key, value
        raise ArgumentError unless key.is_a?(String) || key.is_a?(Symbol)
        @options[:data] ||= {}
        @options[:data][key.to_sym] = value
      end

      def wrapper= value
        if value.is_a? Base
          @wrapper = value
        elsif value.is_a? Hash
          @wrapper = Base.new @view, value
        end
      end

      def capture
        @content = ''.html_safe
        run_callbacks :capture do
          @content = @view.capture(self, &@block) || ''.html_safe unless @block.nil?
        end
        @content
      end

      def capture!
        capture.html_safe
      end
    end
  end
end