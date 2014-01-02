module Bootstrap
  module ViewHelpers
    class Base
      attr_accessor :tag

      def initialize view, *args, &block
        raise ArgumentError if view.nil? || !view.respond_to?(:capture)
        @view = view

        options = {tag: self.class.const_defined?(:TAG) ? self.class.const_get(:TAG) : 'div'}
        options.merge! args.pop.symbolize_keys if args.last.is_a? Hash

        @tag = options.delete(:tag).to_s.downcase
        self.options = options
        @block = block

        self.class.ancestors.each do |klass|
          next unless klass.instance_variable_defined? :@init
          klass.instance_variable_get(:@init).each do |init|
            self.instance_exec *args, &init
          end
        end
      end

      def render *args, &block
        @view.content_tag @tag, content, @options
      end

      def content *args
        @block.nil? ? '' : @view.capture(self, &@block)
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
        raise NotImplementedError
      end

      def self.after_initialize &block
        @init = [] unless instance_variable_defined? :@init
        @init << block
      end

      protected
      def capture
        @block.nil? ? '' : @view.capture(self, &@block)
      end

      def capture!
        capture.html_safe
      end
    end
  end
end