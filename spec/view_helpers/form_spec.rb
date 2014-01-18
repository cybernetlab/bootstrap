require 'spec_helper'

describe Bootstrap::ViewHelpers::Input do
  it { expect(helper).to render_with 'input.form-control[@type="text"]' }

  it 'accepts valid input types' do
    expect(helper type: 'password').to render_with(
      'input.form-control[@type="password"]'
    )
  end

  it 'accepts string arguments as values' do
    expect(helper {'10'}).to render_with 'input.form-control[@value="10"]'
  end
end

describe Bootstrap::ViewHelpers::Form do
  it { expect(helper).to render_with 'form[@role="form"]' }

  # kind
  it 'has `kind` enum' do
    expect(helper).to have_enum(:kind).with(
      html_class_prefix: 'form-',
      values: [:inline, :horizontal]
    )
  end
end
