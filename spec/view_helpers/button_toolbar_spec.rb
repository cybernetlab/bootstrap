require 'spec_helper'

describe Bootstrap::ViewHelpers::ButtonToolbar do
  it {expect(helper).to render_with 'div.btn-toolbar[@role="toolbar"]'}
  it {expect(helper {|h| h.button_group() {|g| g.button 'test'}}).to render_with 'div.btn-toolbar > div.btn-group > button.btn.btn-default[text()="test"]'}
  it {expect(described_class.helper_names).to eq ['toolbar', 'button_toolbar']}

  # method returns safety
  it {expect(helper).to have_safe_method :button_group}
end