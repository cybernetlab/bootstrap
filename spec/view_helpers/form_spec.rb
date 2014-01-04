require 'spec_helper'

describe Bootstrap::ViewHelpers::Form do
  it {expect(rendered).to have_selector 'form[@role="form"]'}
  it {expect(rendered helper class: :test).to have_selector 'form.test[@role="form"]'}
  it {expect(rendered(helper(class: :test) {|g| '<p></p>'.html_safe})).to have_selector 'form.test[@role="form"] > p'}

  it {expect(rendered helper :inline).to have_selector 'form.form-inline'}
  it {expect(rendered helper :horizontal).to have_selector 'form.form-horizontal'}

#  it 'renders child rows' do
#    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
#    helper.row
#  end

  it {expect(described_class.helper_names).to eq 'form'}
end
