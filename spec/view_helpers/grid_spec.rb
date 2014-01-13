require 'spec_helper'

describe Bootstrap::ViewHelpers::Grid do
  it {expect(helper).to render_with 'div.container'}
  it {expect(helper class: :test).to render_with 'div.container.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'div.container.test > p'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  # method returns safety
  it {expect(helper).to have_safe_method :row}
end

describe Bootstrap::ViewHelpers::GridRow do
  it {expect(helper).to render_with 'div.row'}
  it {expect(helper class: :test).to render_with 'div.row.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'div.row.test > p'}

  it 'renders child cells' do
    expect(Bootstrap::ViewHelpers::GridCell).to receive(:new).and_call_original
    helper.cell
  end

  it {expect(helper {|h| h.clear}).to render_with 'div.row > div.clearfix.visible-md'}
  it {expect(helper {|h| h.clear :hidden_large}).to render_with 'div.row > div.clearfix.hidden-lg'}

  # method returns safety
  it {expect(helper).to have_safe_method :cell, :clear}
end

describe Bootstrap::ViewHelpers::GridCell do
  it {expect(helper).to render_with 'div.col-md-3'}
  it {expect(helper class: :test).to render_with 'div.col-md-3.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'div.col-md-3.test > p'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  # method returns safety
  it {expect(helper).to have_safe_method :row}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::SizableColumn}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::PlacableColumn}
end