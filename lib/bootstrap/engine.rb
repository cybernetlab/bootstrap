module Bootstrap
  class Engine < Rails::Engine
    config.to_prepare do
      Assets.register Rails.application.assets
    end
  end
end