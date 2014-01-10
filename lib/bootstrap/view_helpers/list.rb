module Bootstrap
  module ViewHelpers
    class ListItem < Base
      TAG = 'li'

      include Activable
      include Disableable
      include TextContainer
    end


    class ListLinkItem < ListItem
      after_initialize do
        # no link by default
        @link, @link_body, @link_url, @link_options = false, nil, nil, {}

        # prefer to take link body from :link_body option
        @link_body = @options.delete :link_body
        @link = !@link_body.nil? || (!@block.nil? || @args.size > 0 && @args[0].is_a?(String))

        # disable link if body presented
        @link = @link && @body.nil?

        if @link
          # link is present
          @link_body = @args.shift if @block.nil? && @link_body.nil?
          # extract link url from arguments as first occured string or hash
          @link_url = @args.extract_first! String, Hash
          if @link_url.nil?
            # where are no link url in arguments
            # so url options are taked from @options
            @link_url = @options.clone
            @options.clear
          else
            # url link presented in arguments
            # split options to 'li' options and 'link' options
            @options.keys.select {|k| /^link_/ =~ k}.each do |k|
              @link_options[k[5..-1]] = @options.delete k
            end
          end
        end
      end

      after_capture do
        if @link
          # link present
          if @link_body.nil?
            # no link body - take @content as link body
            @content = @view.link_to @content, @link_url, @link_options
          else
            # link body presented - add @content after link
            @content = @view.link_to(@link_body, @link_url, @link_options) + @content
          end
        end
      end
    end

    module List
      extend ActiveSupport::Concern
      TAG = 'ul'

      included do
#        def item *args, &block
#          @items << ListItem.new(@view, *args, &block)
#          Base::EMPTY_HTML
#        end

        after_initialize do
          @items = []
        end

        after_capture do
          @content = @view.capture {@items.reduce(Base::EMPTY_HTML) {|items, item| items += item.render}} + @content
        end
      end

      module ClassMethods
        def item_type type, item_class = ListItem, &block
          define_method type do |*args, &item_block|
            item = item_class.new @view, *args, &item_block
            instance_exec(item, *args, &block) unless block.nil?
            @items << item
            Base::EMPTY_HTML
          end
        end
      end
    end
  end
end