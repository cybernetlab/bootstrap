require 'spec_helper'

describe BootstrapIt::ViewHelpers::DropdownMenu do
  it { expect(helper.render).to have_tag 'ul.dropdown-menu[@role="menu"]' }

  it 'reders devider' do
    expect(helper { |h| h.divider }.render).to have_tag(
      'ul > li.divider[@role="presentation"]'
    )
  end

  it 'renders header' do
    expect(helper { |h| h.header 'test' }.render).to have_tag(
      'ul > li.dropdown-header[@role="presentation"]'
    )
  end

  it 'renders link item' do
    expect(helper { |h| h.link_item 'test', 'http://url' }.render).to have_tag(
      'ul > li[@role="presentation"]' \
      ' > a[@href="http://url"][@role="menuitem"][@tabindex="-1"]'
    )
  end

  it 'renders disabled link item' do
    expect(
      helper { |h| h.link_item 'test', :disabled, 'http://url' }.render
    ).to have_tag(
      'ul > li.disabled[@role="presentation"]' \
      ' > a[@href="http://url"][@role="menuitem"][@tabindex="-1"]'
    )
  end

  it 'supports right-align' do
    expect(helper(align: :right).render).to have_tag 'ul.dropdown-menu.pull-right'
  end

  # options cleaning
  it { expect(helper(align: 'right')).to_not have_option :align }
  it { expect(helper(align: :none)).to_not have_option :align }
end
