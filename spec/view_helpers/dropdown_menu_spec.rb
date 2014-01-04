require 'spec_helper'

describe Bootstrap::ViewHelpers::DropdownMenu do
  it {expect(rendered).to have_selector 'ul.dropdown-menu[@role="menu"]'}

  it {expect(rendered(helper {|h| h.divider})).to have_selector 'ul > li.divider[@role="presentation"]'}
  it {expect(rendered(helper {|h| h.header 'test'})).to have_selector 'ul > li.dropdown-header[@role="presentation"]'}
  it {expect(rendered(helper {|h| h.item 'test', 'http://url'})).to have_selector 'ul > li[@role="presentation"] > a[@href="http://url"][@role="menuitem"][@tabindex="-1"]'}
  it {expect(rendered(helper {|h| h.item 'test', :disabled, 'http://url'})).to have_selector 'ul > li.disabled[@role="presentation"] > a[@href="http://url"][@role="menuitem"][@tabindex="-1"]'}
  it {expect(rendered helper align: :right).to have_selector 'ul.dropdown-menu.pull-right'}

  it {expect(helper align: 'right').to_not have_option :align}
  it {expect(helper align: :none).to_not have_option :align}

  it {expect(described_class.helper_names).to eq 'dropdown_menu'}
end