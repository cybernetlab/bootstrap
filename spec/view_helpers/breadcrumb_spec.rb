require 'spec_helper'

describe BootstrapIt::ViewHelpers::Breadcrumb do
  it { expect(helper.render).to have_tag 'ol.breadcrumb' }
  it { expect(helper).to be_kind_of WrapIt::Container }

  it 'renders active items' do
    expect(helper { |h| h.item :active }.render).to have_tag 'ol > li.active'
  end

  it 'reders links' do
    expect(
      helper { |h| h.link_item 'test', 'http://url' }.render
    ).to have_tag 'ol > li > a[@href="http://url"][text()="test"]'
  end
end
