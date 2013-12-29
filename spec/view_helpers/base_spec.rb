require 'spec_helper'

describe Bootstrap::ViewHelpers::Base do
  # TODO: add specs for initialization and other new stuff

  it 'sets tag to "div" by default' do
    expect(helper.tag).to eq 'div'
  end

  it 'sets default tag from TAG constant' do
    with_helper_class do
      const_set :TAG, 'input'
    end
    expect(helper.tag).to eq 'input'
  end

  it 'sets tag from options' do
    expect(helper(tag: :p).tag).to eq 'p'
  end

  it {expect {helper.render}.to raise_error NotImplementedError}
  it {expect {helper_class.helper_names}.to raise_error NotImplementedError}
end