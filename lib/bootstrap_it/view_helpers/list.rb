module BootstrapIt
  #
  module ViewHelpers
    #
    # ListItem
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class ListItem < WrapIt::Base
      include WrapIt::TextContainer
      include Activable
      include Disableable

      default_tag 'li'
    end


    #
    # ListLinkItem
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    class ListLinkItem < WrapIt::Link
      REGEXP = /\Ali_/
      after_initialize do
        li_options = @options[:li] || @options[:li_options] || {}
        @options.delete(:li)
        @options.delete(:li_options)
        @options.keys.select { |o| REGEXP =~ o }.each do |k|
          li_options[k[3..-1].to_sym] = @options.delete(k)
        end
        @options.key?(:active) &&
          li_options[:active] = @options.delete(:active)
        @options.key?(:disabled) &&
          li_options[:disabled] = @options.delete(:disabled)
        @options.key?(:disable) &&
          li_options[:disabled] = @options.delete(:disable)
        li_args = @arguments.extract!(
          Symbol,
          and: [:active, :disabled, :disable, REGEXP]
        ).map { |a| REGEXP =~ a ? a.to_s[3..-1].to_sym : a }
        li_args << li_options
        wrap ListItem, *li_args
      end
    end
  end
end
