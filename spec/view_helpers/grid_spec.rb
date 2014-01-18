require 'spec_helper'

describe BootstrapIt::ViewHelpers::Grid do
  it { expect(helper).to render_with 'div.container' }

  it 'renders child rows' do
    expect(BootstrapIt::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end
end

describe BootstrapIt::ViewHelpers::GridRow do
  it { expect(helper).to render_with 'div.row' }

  it 'renders child cells' do
    expect(BootstrapIt::ViewHelpers::GridCell).to receive(:new).and_call_original
    helper.cell
  end

  it 'renders clearfix' do
    expect(helper { |h| h.clear }).to render_with(
      'div.row > div.clearfix.visible-md'
    )
  end

  it 'renders clearfix with custom attributes' do
    expect(helper { |h| h.clear :hidden_large }).to render_with(
      'div.row > div.clearfix.hidden-lg'
    )
  end

  # method returns safety
  it { expect(helper).to have_safe_method :clear }
end

describe BootstrapIt::ViewHelpers::GridCell do
  it { expect(helper).to render_with 'div.col-md-3' }

  it 'renders child rows' do
    expect(BootstrapIt::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  # behaviour
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::SizableColumn }
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::PlacableColumn }
end
