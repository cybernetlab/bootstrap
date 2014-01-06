require 'spec_helper'

describe Bootstrap::ViewHelpers::ListItem do
  it {expect(helper).to render_with 'li'}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Disableable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::TextContainer}
end

describe Bootstrap::ViewHelpers::ListLinkItem do
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::ListItem}

  it 'renders link in form link_to {url_options} do ... end' do
    expect(view).to receive(:url_for).with(hash_including controller: 'test').and_return('http://test')
    expect(helper(controller: 'test') {|li| 'link text'}).to render_with 'li > a[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to {url_options}, {options} do ... end' do
    expect(view).to receive(:url_for).with(hash_including controller: 'test').and_return('http://test')
    expect(helper({controller: 'test'}, class: 'n', link_class: 'm') {|li| 'link text'}).to render_with 'li.n > a.m[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to url do ... end' do
    expect(helper('http://test') {|li| 'link text'}).to render_with 'li > a[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to url, {options} do ... end' do
    expect(helper('http://test', class: 'n', link_class: 'm') {|li| 'link text'}).to render_with 'li.n > a.m[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to body, {url_options}' do
    expect(view).to receive(:url_for).with(hash_including controller: 'test').and_return('http://test')
    expect(helper 'link text', controller: 'test').to render_with 'li > a[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to body, {url_options}, {options}' do
    expect(view).to receive(:url_for).with(hash_including controller: 'test').and_return('http://test')
    expect(helper 'link text', {controller: 'test'}, class: 'n', link_class: 'm').to render_with 'li.n > a.m[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to body, url' do
    expect(helper 'link text', 'http://test').to render_with 'li > a[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to body, url, {options}' do
    expect(helper 'link text', 'http://test', class: 'n', link_class: 'm').to render_with 'li.n > a.m[@href="http://test"][text()="link text"]'
  end

  it 'renders link in form link_to link_body, {url_options} with block' do
    expect(view).to receive(:url_for).with(hash_including controller: 'test').and_return('http://test')
    expect(helper(controller: 'test', link_body: 'link text') {|li| '<p></p>'.html_safe}).to render_with 'li > a[@href="http://test"][text()="link text"] + p'
  end
end

describe Bootstrap::ViewHelpers::List do
  it {expect(wrapper).to render_with 'ul'}

  it 'defines item creator method' do
    wrapper_class.class_eval {self.item_type(:header) {|item| item.add_class 'header'}}
    expect(wrapper {|h| h.header text: 'text'}).to render_with 'ul > li.header[text()="text"]'
    expect(wrapper).to have_safe_method :header
  end

#  it {expect(wrapper {|h| h.item text: 'text'}).to render_with 'ul > li[text()="text"]'}

  # method returns safety
  #it {expect(wrapper).to have_safe_method :item}
end