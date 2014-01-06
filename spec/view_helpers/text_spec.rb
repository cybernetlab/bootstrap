require 'spec_helper'

describe Bootstrap::ViewHelpers::TextContainer do
  it {expect(wrapper).to render_with 'p'}

  it 'adds text from first string argument' do
    expect(wrapper(0, 1, 'some text ') {|w| 'with end'}).to render_with 'p', text: 'some text with end'
  end

  it 'adds text from `body` option' do
    expect(wrapper(0, 1, 'some', text: ' text ', body: ' body ') {|w| 'with end'}).to render_with 'p', text: 'some body with end'
  end

  it 'adds text from `text` option' do
    expect(wrapper(0, 1, 'some', text: ' text ') {|w| 'with end'}).to render_with 'p', text: 'some text with end'
  end

  it {expect(wrapper text: '1', body: '2').to_not have_option :text, :body}
end
