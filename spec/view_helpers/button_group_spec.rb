require 'spec_helper'

describe Bootstrap::ViewHelpers::ButtonGroup do
  it {expect(rendered).to have_selector 'div.btn-group'}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Sizable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Justifable}

  # vertical
  it {expect(rendered helper :vertical).to have_selector '.btn-group-vertical'}
  it {expect(rendered helper vertical: true).to have_selector '.btn-group-vertical'}

  # buttons
  it {expect(rendered(helper {|h| h.button 'test'})).to have_selector 'div.btn-group > button.btn.btn-default[text()="test"]'}
  it {expect(rendered(helper {|h| h.radio 'test'})).to have_selector 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-default[text()="test"] > input[@type="radio"]'}
  it {expect(rendered(helper {|h| h.checkbox 'test'})).to have_selector 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-default[text()="test"] > input[@type="checkbox"]'}

  # options cleaning
  it {expect(helper vertical: false).to_not have_option :vertical}

  # class constants
  it {expect(described_class.helper_names).to eq 'button_group'}
  it {expect(helper_class.class_prefix).to eq 'btn-group'}
end