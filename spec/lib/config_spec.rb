require 'spec_helper'

describe Bootstrap::Config do
  it 'has #font_awesome with true by default' do
    expect(described_class.font_awesome).to be_true
    described_class.font_awesome = false
    expect(described_class.font_awesome).to be_false
    described_class.font_awesome = true
  end
end