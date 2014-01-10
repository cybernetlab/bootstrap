require 'spec_helper'

describe Bootstrap::ViewHelpers do
  after {described_class.instance_variable_set :@helpers, nil}

  it 'registers helper' do
    described_class.register_helper :helper, 'Class'
    expect(described_class.instance_variable_get :@helpers).to include ({helper: 'Class'})
    expect {described_class.register_helper :helper, :AnotherClass}.to raise_error ArgumentError, /should be class/
    expect {described_class.register_helper :helper, Class.new}.to raise_error ArgumentError, /from Bootstrap::ViewHelpers::Base/
    expect {described_class.register_helper 'helper', 'AnotherClass'}.to raise_error ArgumentError, /should be Symbols/
    expect {described_class.register_helper :helper, 'AnotherClass'}.to raise_error ArgumentError, /allready exists/
  end

#  it 'injects helper methods' do
#    described_class.register_helper :helper, 'Class'
#    described_class.register_helpers
#    expect(described_class.singleton_methods).to include :helper
#  end
end