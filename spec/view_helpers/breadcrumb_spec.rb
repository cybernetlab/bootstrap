require 'spec_helper'

describe Bootstrap::ViewHelpers::Breadcrumb do
  it { expect(helper).to render_with 'ol.breadcrumb' }
  it { expect(helper).to be_kind_of WrapIt::Container }
  it { expect(helper { |h| h.item :active }).to render_with 'ol > li.active' }
  it 'reders links' do
    expect(
      helper { |h| h.link_item 'test', 'http://url' }
    ).to render_with 'ol > li > a[@href="http://url"][text()="test"]'
  end
end
