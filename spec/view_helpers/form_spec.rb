require 'spec_helper'

describe Bootstrap::ViewHelpers::Form do
  it {expect(helper).to render_with 'form[@role="form"]'}
  it {expect(helper class: :test).to render_with 'form.test[@role="form"]'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'form.test[@role="form"] > p'}

  # kind
  it {expect(helper).to have_enum :kind}
  it {expect(helper :inline).to render_with 'form.form-inline'}
  it {expect(helper :horizontal).to render_with 'form.form-horizontal'}

  it {expect(described_class.helper_names).to eq 'form'}
end
