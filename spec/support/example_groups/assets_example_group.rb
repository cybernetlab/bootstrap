module AssetsExampleGroup
  extend ActiveSupport::Concern

  def compiled asset
    Dir.glob(Rails.root.join('tmp', sprintf("%s-*.%s", *asset.split('.'))))
  end

  included do
    metadata[:type] = :assets

    let :env do
      env = Sprockets::Environment.new Rails.root
      Rails.application.assets.paths.each {|path| env.append_path path}
      Bootstrap::Assets.register env
      env
    end

    let :assets do
      original_verbosity = $VERBOSE
      $VERBOSE = nil
      FileUtils.rm_r Dir.glob(Rails.root.join 'tmp', '*')
      Sprockets::Manifest.new(env, Rails.root.join('tmp'))
    end

    after do
      $VERBOSE = @original_verbosity
      FileUtils.rm_r Dir.glob(Rails.root.join 'tmp', '*')
    end

    RSpec::Matchers.define :compile_with do |expected|
      match_for_should do |asset|
        assets.compile asset
        compiled(asset).any? {|file| File.read(file).include? expected}
      end

      match_for_should_not do |asset|
        assets.compile asset
        compiled(asset).none? {|file| File.read(file).include? expected}
      end
    end

    RSpec::Matchers.define :be_compiled do
      match do |asset|
        assets.compile asset
        compiled(asset).size > 0
      end
    end

    RSpec::Matchers.define :be_in_precompile_list do
      match_for_should do |asset|
        Rails.application.config.assets.precompile.any? do |pre|
          if pre.is_a? Proc
            Rails.application.config.assets.paths.any? {|path| pre.call asset, path}
          elsif pre.is_a? Regexp
            pre.match asset
          end
        end
      end

      match_for_should_not do |asset|
        Rails.application.config.assets.precompile.none? do |pre|
          if pre.is_a? Proc
            Rails.application.config.assets.paths.none? {|path| pre.call asset, path}
          elsif pre.is_a? Regexp
            pre.match asset
          end
        end
      end
    end
  end

  RSpec.configure do |config|
    config.include self, type: :assets, example_group: {file_path: %r(spec/assets)}
  end
end