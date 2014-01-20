require 'spec_helper'

describe BootstrapIt::ViewHelpers::Input do
  it { expect(helper.render).to have_tag 'input.form-control[@type="text"]' }

  it 'accepts valid input types' do
    expect(helper(type: 'password').render).to have_tag(
      'input.form-control[@type="password"]'
    )
  end

  it 'accepts string arguments as values' do
    expect(helper {'10'}.render).to have_tag 'input.form-control[@value="10"]'
  end
end

describe BootstrapIt::ViewHelpers::Form do
  it { expect(helper.render).to have_tag 'form[@role="form"]' }

  # kind
  it 'has `kind` enum' do
    expect(helper).to have_enum(:kind).with(
      html_class_prefix: 'form-',
      values: [:inline, :horizontal]
    )
  end
end
