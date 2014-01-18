module BootstrapIt
  #
  module Assets
    #
    class JSDirectiveProcessor < Sprockets::DirectiveProcessor
      def process_require_directive file
        if file == 'bootstrap_it'
          super 'bootstrap'
        else
          super
        end
      end
    end

    #
    class CSSDirectiveProcessor < Sprockets::DirectiveProcessor
      def process_require_directive(file)
        if file == 'bootstrap_it'
          super 'bootstrap'
          super 'font-awesome' if BootstrapIt.config.font_awesome
        else
          super
        end
      end
    end

    def self.register(assets)
      assets.unregister_preprocessor(
        'application/javascript',
        Sprockets::DirectiveProcessor
      )
      assets.register_preprocessor(
        'application/javascript',
        JSDirectiveProcessor
      )
      assets.unregister_preprocessor('text/css', Sprockets::DirectiveProcessor)
      assets.register_preprocessor('text/css', CSSDirectiveProcessor)
      config = BootstrapIt.config
      Rails.application.config.assets.paths << Engine.root.join(
        'upstream', 'bootstrap', config.bootstrap_version, 'javascript'
      )
      Rails.application.config.assets.paths << Engine.root.join(
        'upstream', 'bootstrap', config.bootstrap_version, 'stylesheets'
      )
      if config.font_awesome
        Rails.application.config.assets.paths << Engine.root.join(
          'upstream', 'font-awesome',
          config.font_awesome_version, 'stylesheets'
        )
      end
      Rails.application.config.assets.precompile << proc do |file, path|
        path == Engine.root.join(
          'upstream', 'bootstrap',
          config.bootstrap_version,
          'fonts'
        ) &&
          file =~ /\.(otf|eot|svg|ttf|woff)/ ||
            path == Engine.root.join(
              'upstream', 'font-awesome',
              config.font_awesome_version,
              'fonts'
            ) &&
            file =~ /\.(otf|eot|svg|ttf|woff)/
      end
    end
  end
end
