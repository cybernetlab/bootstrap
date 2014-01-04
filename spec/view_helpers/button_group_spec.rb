require 'spec_helper'

describe Bootstrap::ViewHelpers::ButtonGroup do
  it {expect(rendered).to have_selector 'div.btn-group'}
  it {expect(rendered(helper {|h| h.button 'test'})).to have_selector 'div.btn-group > button.btn.btn-default[text()="test"]'}
  it {expect(rendered(helper {|h| h.radio 'test'})).to have_selector 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-default[text()="test"] > input[@type="radio"]'}
  it {expect(rendered(helper {|h| h.checkbox 'test'})).to have_selector 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-default[text()="test"] > input[@type="checkbox"]'}
  it {expect(described_class.helper_names).to eq 'button_group'}
end