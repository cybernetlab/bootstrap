require 'spec_helper'

describe Bootstrap::ViewHelpers::DropdownMenu do
  it {expect(helper).to render_with 'ul.dropdown-menu[@role="menu"]'}

  it {expect(helper {|h| h.divider}).to render_with 'ul > li.divider[@role="presentation"]'}
  it {expect(helper {|h| h.header 'test'}).to render_with 'ul > li.dropdown-header[@role="presentation"]'}
  it {expect(helper {|h| h.item 'test', 'http://url'}).to render_with 'ul > li[@role="presentation"] > a[@href="http://url"][@role="menuitem"][@tabindex="-1"]'}
  it {expect(helper {|h| h.item 'test', :disabled, 'http://url'}).to render_with 'ul > li.disabled[@role="presentation"] > a[@href="http://url"][@role="menuitem"][@tabindex="-1"]'}
  it {expect(helper align: :right).to render_with 'ul.dropdown-menu.pull-right'}

  it {expect(helper align: 'right').to_not have_option :align}
  it {expect(helper align: :none).to_not have_option :align}

  # method returns safety
  it {expect(helper).to have_safe_method :divider, :header, :item}
end