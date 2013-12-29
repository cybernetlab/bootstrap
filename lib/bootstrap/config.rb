module Bootstrap
  module Config
    def self.font_awesome
      @font_awesome = true unless instance_variable_defined? :@font_awesome
      @font_awesome == true
    end

    def self.font_awesome= value
      @font_awesome = value.is_a? TrueClass
    end
  end

  def self.config
    Config
  end
end