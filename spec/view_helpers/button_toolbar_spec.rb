require 'spec_helper'

describe BootstrapIt::ViewHelpers::ButtonToolbar do
  it { expect(helper.render).to have_tag 'div.btn-toolbar[@role="toolbar"]' }

  it 'reders button group' do
    expect(
      helper { |h| h.button_group { |g| g.button 'test' } }.render
    ).to have_tag(
      'div.btn-toolbar > div.btn-group' \
      ' > button.btn.btn-default[text()="test"]'
    )
  end
end
