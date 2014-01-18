require 'spec_helper'

describe Bootstrap::ViewHelpers::ButtonToolbar do
  it { expect(helper).to render_with 'div.btn-toolbar[@role="toolbar"]' }

  it 'reders button group' do
    expect(
      helper { |h| h.button_group { |g| g.button 'test' } }
    ).to render_with(
      'div.btn-toolbar > div.btn-group' \
      ' > button.btn.btn-default[text()="test"]'
    )
  end
end
