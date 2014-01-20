require 'spec_helper'

describe BootstrapIt::ViewHelpers::Pagination do
  it { expect(helper.render).to have_tag 'ul.pagination' }
  it { expect(helper).to be_kind_of WrapIt::Container }
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Sizable }

  it 'renders links' do
    expect(helper { |h| h.link_item 'test', 'http://url' }.render).to have_tag(
      'ul > li > a[@href="http://url"][text()="test"]'
    )
  end
end

describe BootstrapIt::ViewHelpers::Pager do
  it { expect(helper.render).to have_tag 'ul.pager' }
  it { expect(helper).to be_kind_of WrapIt::Container }

  it 'renders links' do
    expect(helper { |h| h.link_item 'test', 'http://url' }.render).to have_tag(
      'ul > li > a[@href="http://url"][text()="test"]'
    )
  end

  it 'renders previous' do
    expect(helper { |h| h.previous 'test', 'http://url' }.render).to have_tag(
      'ul > li.previous > a[@href="http://url"][text()="test"]'
    )
  end

  it 'renders next' do
    expect(helper { |h| h.next 'test', 'http://url' }.render).to have_tag(
      'ul > li.next > a[@href="http://url"][text()="test"]'
    )
  end
end
