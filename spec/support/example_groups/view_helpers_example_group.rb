module ViewHelpersExampleGroup
  extend ActiveSupport::Concern

  def with_helper_class &block
    helper_class.class_eval &block if block_given?
  end

  def helper *args, &block
    @helper ||= helper_class.new view, *args, &block
  end

  def rendered str = nil
    if block_given?
      Capybara::Node::Simple.new(yield)
    elsif str.is_a? String
      Capybara::Node::Simple.new(str)
    elsif str.respond_to? :render
      Capybara::Node::Simple.new(str.render)
    else
      Capybara::Node::Simple.new(helper.render)
    end
  end

  included do
    metadata[:type] = :view_helpers

    let(:view) {ActionView::Base.new}
    let(:helper_class) {Class.new described_class}
  end

  RSpec.configure do |config|
    config.include self, type: :view_helpers, example_group: {file_path: %r(spec/view_helpers)}
  end
end