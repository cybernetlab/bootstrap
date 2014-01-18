module BootstrapIt
  #
  class Engine < Rails::Engine
    config.to_prepare do
      Rails.application.config.i18n.load_path +=
        Dir[Engine.root.join('lib', 'bootstrap_it', 'locales', '*.yml')]
      Assets.register(Rails.application.assets)
    end

    initializer 'bootstrap_it.configure_view_controller' do |app|
      ActiveSupport.on_load(:action_view) do
        include WrapIt.helpers
        include BootstrapIt::LayoutHelpers
      end

#      ActiveSupport.on_load :action_controller do
#        include MyGem::ActionController::Filters
#      end
    end

#    initializer 'bootstrap.view_helpers' do
#      ViewHelpers.register_helpers ActionView::Base
#    end
  end
end
