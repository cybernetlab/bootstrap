require 'spec_helper'

describe BootstrapIt::ViewHelpers::ListItem do
  it { expect(helper).to render_with 'li' }
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Disableable }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }
end

describe BootstrapIt::ViewHelpers::ListLinkItem do
  it { expect(helper).to be_kind_of WrapIt::Link }

  it { expect(helper).to render_with 'li > a' }

  it 'passes `li` or `li_options` as options to li' do
    %i(li li_options).each do |key|
      @helper = nil
      expect(helper(key => {class: 'list'})).to render_with 'li.list > a'
    end
  end

  it 'passes `li_*` options to li' do
    expect(helper(li_class: 'list')).to render_with 'li.list > a'
  end

  it 'passes `li_*` arguments to li' do
    expect(helper(:li_active)).to render_with 'li.active > a'
  end

  it 'passes `active` and `disable` arguments to li' do
    %i(active disabled disable).each do |key|
      @helper = nil
      html_class = key == :disable ? :disabled : key
      expect(helper(key)).to render_with "li.#{html_class} > a"
    end
  end

  it 'passes `active` and `disable` options to li' do
    %i(active disabled disable).each do |key|
      @helper = nil
      html_class = key == :disable ? :disabled : key
      expect(helper(key => true)).to render_with "li.#{html_class} > a"
    end
  end

  it 'keeps not related to list optioins and arguments' do
    expect(
      helper('text', 'url', li_class: 'list', class: 'link')
    ).to render_with 'li.list > a.link[@href="url"][text()="text"]'
  end
end
