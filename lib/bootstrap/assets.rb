module Bootstrap
  module Assets
    class JSDirectiveProcessor < Sprockets::DirectiveProcessor
      def process_require_directive file
        if file == 'bootstrap'
          super 'bootstrap'
        else
          super
        end
      end
    end
  
    class CSSDirectiveProcessor < Sprockets::DirectiveProcessor
      def process_require_directive file
        if file == 'bootstrap'
          super 'bootstrap'
          super 'font-awesome' if Bootstrap.config.font_awesome
        else
          super
        end
      end
    end

    def self.register assets
      assets.unregister_preprocessor 'application/javascript', Sprockets::DirectiveProcessor
      assets.register_preprocessor 'application/javascript', JSDirectiveProcessor
      assets.unregister_preprocessor 'text/css', Sprockets::DirectiveProcessor
      assets.register_preprocessor 'text/css', CSSDirectiveProcessor
      Rails.application.config.assets.precompile << Proc.new do |file, path|
        path == Engine.root.join('app', 'assets', 'fonts') && file =~ /\.(otf|eot|svg|ttf|woff)/
      end
    end
  end
end