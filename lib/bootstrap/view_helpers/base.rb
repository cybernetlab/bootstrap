module Bootstrap
  module ViewHelpers
    class Base
      include ActiveSupport::Callbacks

      define_callbacks :initialize
      define_callbacks :capture, terminator: 'result == false'
      define_callbacks :render, terminator: 'result == false'

      attr_accessor :tag
      attr_reader :options

      def initialize view, *args, &block
        raise ArgumentError if view.nil? || !view.respond_to?(:capture)
        @flags, @enums, @view, @block, @wrapper, @content = {}, {}, view, block, nil, nil

        prepare_args(*args)

        run_callbacks :initialize do
          options = {tag: self.class.const_defined?(:TAG) ? self.class.const_get(:TAG) : 'div'}
          options.merge! @args.pop.symbolize_keys if @args.last.is_a? Hash

          @tag = options.delete(:tag).to_s.downcase
          self.options = options

          keys = @options.keys
          self.class.get_derived_hash(:@opt_index).each do |name, opts|
            next unless keys.include? name
            value = @options.delete name
            if opts[:type] == :flag
              self.send "#{opts[:name]}=", value == true
            else
              @enums[opts[:name]] = value if opts[:values].include? value
            end
          end

          arg_index = self.class.get_derived_hash :@arg_index
          @args.extract!(Symbol, and: [arg_index.keys]).each do |arg|
            if arg_index[arg][:type] == :flag
              self.send "#{arg_index[arg][:name]}=", true
            else
              @enums[arg_index[arg][:name]] = arg
            end
          end

          @helper_name = options.delete :helper_name

          self.class.get_derived_array(:@html_class).each {|c| add_class c}
        end
      end

      def render *args, &render_block
        return @content unless @content.nil?
        @content = EMPTY_HTML

        run_callbacks :capture do
          @content ||= EMPTY_HTML
          @content += @view.capture(self, &@block) || EMPTY_HTML unless @block.nil?
        end

        args.flatten.each {|a| @content += a if a.is_a? String}
        @content += instance_exec(self, &render_block) unless render_block.nil?
           
        run_callbacks :render do
          @options.select! {|k, v| !v.blank?}
          @content = @view.content_tag @tag, @content, @options
        end
            
        @content = @wrapper.render @content.html_safe if @wrapper.is_a? Base
        if @view.instance_variable_get(:@output_buffer).nil?
          @content
        else
          @view.concat(@content)
          EMPTY_HTML
        end
      end

      def add_class value
        if value.is_a? Array
          @options[:class] += value.flatten.map {|v| v.to_s}
        else
          @options[:class].push(value.to_s)
        end
        @options[:class].uniq!
        self # allow chaining
      end

      def remove_class value
        if value.is_a? Array
          value.flatten.each {|v| @options[:class].delete v if @options[:class].include? v}
        else
          @options[:class].delete value if @options[:class].include? value
        end
        self # allow chaining
      end

      def set_data key, value
        raise ArgumentError unless key.is_a?(String) || key.is_a?(Symbol)
        @options[:data] ||= {}
        @options[:data][key.to_sym] = value
        self # allow chaining
      end

      def unset_data key
        raise ArgumentError unless key.is_a?(String) || key.is_a?(Symbol)
        @options[:data] ||= {}
        @options[:data].delete key.to_sym
        self # allow chaining
      end

      def have_class? value = nil, &block
        if value.is_a? Regexp
          @options[:class].any? {|c| value.match c}
        elsif value.is_a? String
          @options[:class].any? {|c| value == c}
        elsif value.is_a? Array
          @options[:class].any? {|c| value.include? c}
        elsif block_given?
          @options[:class].any?(&block)
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
          @options[:class].none?(&block)
        else
          false
        end
      end

      def self.helper name, helper_class, &block
        helper_class = helper_class.name if helper_class.is_a? Class
        define_method name do |*h_args, &h_block|
          begin
            options = h_args.last.is_a?(Hash) ? h_args.last : h_args.push({}).last
            options[:helper_name] = name.to_s
            obj = helper_class.constantize.new(@view, *h_args, &h_block)
            instance_exec obj, &block unless block.nil?
            obj.render
          rescue NameError
            raise NameError.new "Helper class #{helper_class} doesn't exists"
          end
        end
      end

      def self.html_class value
        value = value.is_a?(Array) ? value.flatten : [value]
        value.map! {|v| v.to_s}
        @html_class ||= []
        @html_class += value
        @html_class.uniq!
      end

      def self.class_prefix
        ([self] + ancestors).each {|c| return c.instance_variable_get :@class_prefix if c.instance_variable_defined?(:@class_prefix)}
        nil
      end

      EMPTY_HTML = ''.html_safe

      protected

      def self.helper_names= value
        @helper_names = value.is_a?(Array) ? value.flatten : value
      end

      def self.class_prefix= value
        @class_prefix = value.to_s
      end

      # --- flags
      def self.flag name, options = {}, &block
        getter = "#{name}?".to_sym
        setter = "#{name}=".to_sym
        name = name.to_sym unless name.is_a? Symbol
        options[:block] = block if block_given?
        options[:type] = :flag
        options[:name] = name
        @arg_index ||= {}
        @arg_index[name] = options
        @opt_index ||= {}
        @opt_index[name] = options
        options[:aliases].each do |a|
          @arg_index[a] = options
          @opt_index[a] = options
        end if options[:aliases].is_a? Array

        define_method getter do
          @flags[name] == true
        end

        define_method setter do |value|
          value = value == true
          @flags[name] = value
          if options.key? :html_class
            value ? add_class(options[:html_class]) : remove_class(options[:html_class])
          end
          self.instance_exec(value, &options[:block]) if options[:block].is_a? Proc
        end
      end

      # --- enums
      def self.enum name, values, options = {}
        getter = "#{name}".to_sym
        setter = "#{name}=".to_sym
        name = name.to_sym unless name.is_a? Symbol
        options[:type] = :enum
        options[:name] = name
        options[:values] = values
        @arg_index ||= {}
        values.each {|v| @arg_index[v] = options}
        @opt_index ||= {}
        @opt_index[name] = options

        define_method getter do
          @enums[name]
        end

        define_method setter do |value|
          return unless values.include? value
          @enums[name] = value
        end
      end

      def self.after_initialize &block
        set_callback :initialize, :after, &block
      end

      def self.after_capture &block
        set_callback :capture, :after, &block
      end

      def self.after_render &block
        set_callback :render, :after, &block
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

      def wrapper= value
        if value.nil?
          @wrapper = nil
        elsif value.is_a? Base
          @wrapper = value
        elsif value.is_a? Hash
          @wrapper = Base.new @view, value
        end
      end

      def do_capture
        run_callbacks :capture do
          @content += @view.capture(self, &@block) || ''.html_safe unless @block.nil?
        end
        @content
      end

      def capture!
        capture.html_safe
      end

      private

      def self.get_derived_hash name
        hash = instance_variable_defined?(name) ? instance_variable_get(name) : {}
        ancestors.each do |ancestor|
          break if ancestor == Base
          next unless ancestor.instance_variable_defined? name
          hash = ancestor.instance_variable_get(name).merge hash
        end
        hash
      end

      def self.get_derived_array name
        arr = instance_variable_defined?(name) ? instance_variable_get(name) : []
        ancestors.each do |ancestor|
          break if ancestor == Base
          next unless ancestor.instance_variable_defined? name
          arr += ancestor.instance_variable_get name
        end
        arr
      end

      def prepare_args *args
        @args = args

        do_compare = Proc.new do |target, *c_args|
          result = false
          result = yield target if block_given?
          unless result
            options = c_args.last.is_a?(Hash) ? c_args.pop : {}
            c_args.each do |dest|
              if dest.is_a? Array
                result = dest.include? target
              elsif dest.is_a? Regexp
                target = target.to_s unless target.is_a? String
                result = dest.match target
              elsif dest.is_a? Class
                result = target.is_a? dest
              else
                result = dest == target
              end
              break if result
            end
            result &&= do_compare.call target, *options[:and] if options[:and].is_a? Array
          end
          result
        end

        @args.define_singleton_method :extract! do |*e_args, &e_block|
          extracted = []
          select! do |arg|
            got_it = do_compare.call arg, *e_args, &e_block
            extracted << arg if got_it
            !got_it
          end
          extracted
        end

        @args.define_singleton_method :extract_first! do |*e_args, &e_block|
          index = find_index {|arg| do_compare.call arg, *e_args, &e_block}
          index.nil? ? nil : delete_at(index)
        end
      end
    end
  end
end