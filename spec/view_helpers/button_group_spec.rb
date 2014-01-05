require 'spec_helper'

describe Bootstrap::ViewHelpers::ButtonGroup do
  it {expect(helper).to render_with 'div.btn-group'}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Sizable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Justifable}

  # vertical
  it {expect(helper :vertical).to render_with '.btn-group-vertical'}
  it {expect(helper vertical: true).to render_with '.btn-group-vertical'}

  # buttons
  it {expect(helper {|h| h.button 'test'}).to render_with 'div.btn-group > button.btn.btn-default[text()="test"]'}
  it {expect(helper {|h| h.radio 'test'}).to render_with 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-default[text()="test"] > input[@type="radio"]'}
  it {expect(helper {|h| h.checkbox 'test'}).to render_with 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-default[text()="test"] > input[@type="checkbox"]'}

  # options cleaning
  it {expect(helper vertical: false).to_not have_option :vertical}

  # class constants
  it {expect(described_class.helper_names).to eq 'button_group'}
  it {expect(described_class.class_prefix).to eq 'btn-group'}
end