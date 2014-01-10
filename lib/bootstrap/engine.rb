module Bootstrap
  class Engine < Rails::Engine
    config.to_prepare do
      Assets.register Rails.application.assets
    end

    initializer 'bootstrap.configure_view_controller' do |app|
      ActiveSupport.on_load :action_view do
        ViewHelpers.register_helpers
        include ViewHelpers
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