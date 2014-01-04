require 'spec_helper'

describe Bootstrap::ViewHelpers::ButtonToolbar do
  it {expect(rendered).to have_selector 'div.btn-toolbar[@role="toolbar"]'}
  it {expect(rendered(helper {|h| h.button_group() {|g| g.button 'test'}})).to have_selector 'div.btn-toolbar > div.btn-group > button.btn.btn-default[text()="test"]'}
  it {expect(described_class.helper_names).to eq ['toolbar', 'button_toolbar']}
end