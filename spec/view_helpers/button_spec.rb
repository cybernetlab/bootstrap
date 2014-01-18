require 'spec_helper'

describe Bootstrap::ViewHelpers::Button do
  it { expect(helper).to render_with 'button.btn.btn-default[@type="button"]' }

  it 'allows `submit` type' do
    expect(helper type: 'submit').to render_with(
      'button.btn.btn-default[@type="submit"]'
    )
  end

  it 'allows `a` tag' do
    expect(helper tag: :a).to render_with 'a.btn.btn-default[@role="button"]'
  end

  it 'allows `input` tag' do
    expect(helper tag: :input).to render_with(
      'input.btn.btn-default[@type="button"]'
    )
  end

  it 'allows `input` with `submit` type' do
    expect(helper tag: :input, type: :submit).to render_with(
      'input.btn.btn-default[@type="submit"]'
    )
  end

  it 'changes custom tags to `button`' do
    expect(helper tag: :p).to render_with 'button.btn.btn-default'
  end

  # method returns safety
  it { expect(helper).to have_safe_method :icon }

  # behaviour
  it { expect(helper).to be_kind_of Bootstrap::ViewHelpers::Activable }
  it { expect(helper).to be_kind_of Bootstrap::ViewHelpers::Disableable }
  it { expect(helper).to be_kind_of Bootstrap::ViewHelpers::Sizable }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }

  # appearence
  it { expect(helper).to have_enum :appearence }

  # icons
  it 'renders icon throw options' do
    expect(helper icon: :bell).to render_with(
      'button.btn.btn-default > i.fa.fa-bell'
    )
  end

  it 'renders icon with helper' do
    expect(helper { |b| b.icon :star }).to render_with(
      'button.btn.btn-default > i.fa.fa-star'
    )
  end

  # block
  it { expect(helper).to have_flag(:block).with(html_class: ['btn-block']) }

  # radios
  it 'renders radio' do
    expect(helper(
      'text',
      name: 'group-name',
      id: 'option1',
      value: 'v1',
      class: 'someclass',
      helper_name: 'radio'
    )).to render_with(
      'label.btn.btn-default.someclass[text()="text"][@label_for="option1"]' \
      ' > input[@type="radio"][@name="group-name"][@id="option1"]' \
      '[@value="v1"]'
    )
  end

  # checkboxes
  it 'renders chackbox' do
    expect(helper(
      'text',
      name: 'group-name',
      id: 'option1',
      value: 'v1',
      class: 'someclass',
      helper_name: 'checkbox'
    )).to render_with(
      'label.btn.btn-default.someclass[text()="text"] >' \
      ' input[@type="checkbox"][@name="group-name"]' \
      '[@id="option1"][@value="v1"]'
    )
  end

  # toggling
  it { expect(helper).to have_flag :toggle }
  it { expect(helper :toggle).to render_with 'button[@data-toggle="button"]' }

  # state text
  it 'extracts state text from options' do
    expect(helper loading_text: 'text').to render_with(
      'button[@data-loading-text="text"]'
    )
  end

  # options cleaning
  it 'removes button-specific options' do
    expect(helper(
      icon: :bell,
      block: true,
      toggle: false,
      some_text: false
    )).to_not have_option :icon, :block, :toggle, :some_text
  end

  # class constants
  it { expect(described_class.html_class_prefix).to eq 'btn-' }
end

describe Bootstrap::ViewHelpers::DropdownButton do
  # behaviour
  it 'subclassed from DropdownMenuWrapper' do
    expect(helper).to be_kind_of Bootstrap::ViewHelpers::DropdownMenuWrapper
  end

  # dropdown
  it 'renders dropdown toggle' do
    expect(helper('action text') { |b| b.divider }).to render_with(
      'div.btn-group > button.dropdown-toggle[@data-toggle="dropdown"]' \
      '[text()="action text"] > span.caret'
    )
  end

  it 'renders dropdown menu' do
    expect(helper('action text') { |b| b.divider }).to render_with(
      'div.btn-group > button + ul.dropdown-menu > li.divider'
    )
  end
  # splitted dropdown
  it { expect(helper).to have_flag :splitted }

  it 'renders splitted toggle button' do
    expect(
      helper(:splitted, :danger, 'action') { |b| b.divider }
    ).to render_with 'div.btn-group > button.btn-danger[text()="action"]'
  end

  it 'renders spliited toggle' do
    expect(
      helper(:splitted, :danger, 'action') { |b| b.divider }
    ).to render_with(
      'div.btn-group' \
      ' > button.btn-danger.dropdown-toggle[@data-toggle="dropdown"]' \
      ' > span.caret'
    )
  end

  it 'renders splitted dropdown menu' do
    expect(
      helper(:splitted, :danger, 'action') { |b| b.divider }
    ).to render_with 'div.btn-group > ul.dropdown-menu > li.divider'
  end

  # dropup
  it { expect(helper).to have_flag :dropup }

  it 'renders dropup' do
    expect(
      helper(:dropup) { |b| b.divider }
    ).to render_with 'div.btn-group.dropup'
  end
end
