#
module BootstrapIt
  #
  # Configuration
  #
  # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
  #
  module Config
    ASSETS_SOURCES = %i[cdn precompiled]

    def self.font_awesome
      @font_awesome = true unless instance_variable_defined?(:@font_awesome)
      @font_awesome == true
    end

    def self.font_awesome=(value)
      @font_awesome = value == true
    end

    def self.font_awesome_version
      @font_awesome_version ||= BootstrapIt::FONTAWESOME_LATEST
    end

    def self.font_awesome_version=(value)
      return unless /\d+\.\d+\.\d+/ =~ value
      @font_awesome_version = value
    end

    def self.bootstrap_version
      @bootstrap_version ||= BootstrapIt::BOOTSTRAP_LATEST
    end

    def self.bootstrap_version=(value)
      return unless /\d+\.\d+\.\d+/ =~ value
      @bootstrap_version = value
    end

    def self.assets_source
      @assets_source ||= :precompiled
    end

    def self.assets_source=(value)
      @assets_source = ASSETS_SOURCES.include?(value) ? value : :precompiled
    end
  end

  def self.config
    Config
  end
end
