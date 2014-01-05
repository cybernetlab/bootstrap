module ViewHelpersExampleGroup
  extend ActiveSupport::Concern

  def helper *args, &block
    @helper ||= described_class.new view, *args, &block
  end

  def wrapper *args, &block
    @wrapper ||= wrapper_class.new view, *args, &block
  end

  def successor *args, &block
    @successor ||= successor_class.new view, *args, &block
  end

  included do
    metadata[:type] = :view_helpers

    after {@helper, @wrapper, @successor = nil, nil, nil}
    let(:view) {ActionView::Base.new}
    let(:successor_class) {Class.new described_class}
    let(:wrapper_class) do
      mod = described_class
      Class.new Bootstrap::ViewHelpers::Base do
        include mod
      end
    end

    RSpec::Matchers.define :have_option do |*options|
      match_for_should do |obj|
        actual = obj.instance_variable_get :@options
        options.flatten!
        actual.select {|o| options.include? o}.size == options.size
      end

      match_for_should_not do |obj|
        actual = obj.instance_variable_get :@options
        options.flatten!
        actual.select {|o| options.include? o}.size == 0
      end
    end

    RSpec::Matchers.define :render_with do |selector, options = {}|
      match_for_should do |actual|
        Capybara::Node::Simple.new(actual.render).has_selector? selector, options
      end

      match_for_should_not do |actual|
        Capybara::Node::Simple.new(actual.render).has_no_selector? selector, options
      end

      failure_message_for_should do |actual|
        "expected that #{actual.render} would have selector #{selector}"
      end

      failure_message_for_should_not do |actual|
        "expected that #{actual.render} would not have selector #{selector}"
      end
    end

    RSpec::Matchers.define :have_flag do |*flags|
      match do |obj|
        actual = obj.class.send :flags
        flags.select {|flag| actual.include?(flag)}.size == flags.size
      end

      failure_message_for_should do |obj|
        "expected that #{obj.class.name} with flags #{obj.class.send :flags} would have flags #{flags}"
      end
    end

    RSpec::Matchers.define :have_enum do |*enums|
      match do |obj|
        actual = obj.class.send :enums
        enums.select {|enum| actual.include?(enum)}.size == enums.size
      end

      failure_message_for_should do |obj|
        "expected that #{obj.class.name} with enums #{obj.class.send :enums} would have enums #{enums}"
      end
    end
  end

  RSpec.configure do |config|
    config.include self, type: :view_helpers, example_group: {file_path: %r(spec/view_helpers)}
  end
end