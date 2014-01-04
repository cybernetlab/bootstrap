module Bootstrap
  module ViewHelpers
    class Base
      include ActiveSupport::Callbacks

      define_callbacks :initialize, :capture

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
        end

        @wrapper = Base.new @view, @wrapper if @wrapper.is_a? Hash
      end

      def render *args
        content = capture
        args.flatten.each {|a| content += a if a.is_a? String}
        content += yield self if block_given?
        content = @view.content_tag @tag, content, @options
        content = @wrapper.render content.html_safe if @wrapper.is_a? Base
        content
      end

      attr_reader :options
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

      def self.helper_names
        instance_variable_defined?(:@helper_names) ? @helper_names : nil
      end

      protected
      def self.helper_names= value
        @helper_names = value.is_a?(Array) ? value.flatten : value
      end

      def capture
        @content = nil
        run_callbacks :capture do
          @content = @block.nil? ? ''.html_safe : @view.capture(self, &@block)
        end
        @content
      end

      def capture!
        capture.html_safe
      end
    end
  end
end