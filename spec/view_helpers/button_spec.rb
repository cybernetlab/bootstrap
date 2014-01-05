require 'spec_helper'

describe Bootstrap::ViewHelpers::Button do
  it {expect(helper).to render_with 'button.btn.btn-default[@type="button"]'}
  it {expect(helper type: 'submit').to render_with 'button.btn.btn-default[@type="submit"]'}
  it {expect(helper tag: :a).to render_with 'a.btn.btn-default[@role="button"]'}
  it {expect(helper tag: :input).to render_with 'input.btn.btn-default[@type="button"]'}
  it {expect(helper tag: :input, type: :submit).to render_with 'input.btn.btn-default[@type="submit"]'}
  it {expect(helper tag: :p).to render_with 'button.btn.btn-default'}
  it {expect(helper class: :test).to render_with 'button.btn.btn-default.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'button.btn.btn-default.test > p'}

  # method returns safety
  it {expect(helper).to have_safe_method :icon}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Activable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Disableable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Sizable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::DropdownMenuWrapper}

  # text
  it {expect(helper 'test text').to render_with 'button.btn.btn-default[text()="test text"]'}
  it {expect(helper text: 'test text').to render_with 'button.btn.btn-default[text()="test text"]'}

  # fashion
  it {expect(helper).to have_enum :fashion}
  it 'supports many fashions' do
    %i[default primary success info warning danger link].each do |type|
      @helper = nil; expect(helper type).to render_with "button.btn.btn-#{type}"
      @helper = nil; expect(helper fashion: type).to render_with "button.btn.btn-#{type}"
    end
  end

  # icons
  it {expect(helper icon: :bell).to render_with 'button.btn.btn-default > i.fa.fa-bell'}
  it {expect(helper {|b| b.icon :star}).to render_with 'button.btn.btn-default > i.fa.fa-star'}

  # dropdown
  it {expect(helper('action text') {|b| b.divider}).to render_with 'div.btn-group > button.dropdown-toggle[@data-toggle="dropdown"][text()="action text"] > span.caret'}
  it {expect(helper('action text') {|b| b.divider}).to render_with 'div.btn-group > ul.dropdown-menu > li.divider'}
  # splitted dropdown
  it {expect(helper).to have_flag :splitted}
  it {expect(helper(:splitted, :danger, 'action') {|b| b.divider}).to render_with 'div.btn-group > button.btn-danger[text()="action"]'}
  it {expect(helper(:splitted, :danger, 'action') {|b| b.divider}).to render_with 'div.btn-group > button.btn-danger.dropdown-toggle[@data-toggle="dropdown"] > span.caret'}
  it {expect(helper(:splitted, :danger, 'action') {|b| b.divider}).to render_with 'div.btn-group > ul.dropdown-menu > li.divider'}
  # dropup
  it {expect(helper).to have_flag :dropup}
  it {expect(helper(:dropup) {|b| b.divider}).to render_with 'div.btn-group.dropup'}

  # block
  it {expect(helper).to have_flag(:block).with(html_class: 'btn-block')}

  # radios
  it {expect(helper 'text', name: 'group-name', id: 'option1', value: 'v1', class: 'someclass', helper_name: 'radio').to render_with 'label.btn.btn-default.someclass[text()="text"][@label_for="option1"] > input[@type="radio"][@name="group-name"][@id="option1"][@value="v1"]'}

  # checkboxes
  it {expect(helper 'text', name: 'group-name', id: 'option1', value: 'v1', class: 'someclass', helper_name: 'checkbox').to render_with 'label.btn.btn-default.someclass[text()="text"] > input[@type="checkbox"][@name="group-name"][@id="option1"][@value="v1"]'}

  # toggling
  it {expect(helper).to have_flag :toggle}
  it {expect(helper :toggle).to render_with 'button[@data-toggle="button"]'}

  # state text
  it {expect(helper loading_text: 'text').to render_with 'button[@data-loading-text="text"]'}

  # options cleaning
  it {expect(helper icon: :bell, block: true, toggle: false, some_text: false, splitted: true, dropup: true).to_not have_option :icon, :block, :toggle, :some_text, :splitted, :dropup}

  # class constants
  it {expect(described_class.helper_names).to eq ['button', 'radio', 'checkbox']}
  it {expect(described_class.class_prefix).to eq 'btn'}
end
