require 'spec_helper'

describe BootstrapIt::ViewHelpers::ButtonGroup do
  it { expect(helper.render).to have_tag 'div.btn-group' }

  # behaviour
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Sizable }
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Justifable }

  # vertical
  it 'has vertical switch' do
    expect(
      helper
    ).to have_flag(:vertical).with(html_class: ['btn-group-vertical'])
  end

  # buttons
  it 'renders buttons' do
    expect(helper { |h| h.button 'test' }.render).to have_tag(
      'div.btn-group > button.btn.btn-default[text()="test"]'
    )
  end

  it 'renders radios' do
    expect(helper { |h| h.radio 'test' }.render).to have_tag(
      'div.btn-group[@data-toggle="buttons"]' \
      ' > label.btn.btn-default[text()="test"] > input[@type="radio"]'
    )
  end

  it 'renders checkboxes' do
    expect(helper { |h| h.checkbox 'test' }.render).to have_tag(
      'div.btn-group[@data-toggle="buttons"]' \
      ' > label.btn.btn-default[text()="test"] > input[@type="checkbox"]'
    )
  end

  # class constants
  it { expect(described_class.html_class_prefix).to eq 'btn-group-' }
end
