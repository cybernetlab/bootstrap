require 'spec_helper'

describe Bootstrap::ViewHelpers::Nav do
  it {expect(helper).to render_with 'ul.nav'}

  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Justifable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::List}

  it {expect(helper {|h| h.link_item :active}).to render_with 'ul > li.active'}
  it {expect(helper {|h| h.dropdown('text') {|d| d.header 'header'}}).to render_with 'ul > li.dropdown > a.dropdown-toggle[@data-toggle="dropdown"][@href="#"][text()="text "]'}

  # method returns safety
  it {expect(helper).to have_safe_method :link_item, :dropdown}
end

describe Bootstrap::ViewHelpers::NavPills do
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Nav}
  it {expect(helper).to render_with 'ul.nav.nav-pills'}
end

describe Bootstrap::ViewHelpers::NavTabs do
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Nav}
  it {expect(helper).to render_with 'ul.nav.nav-tabs'}
end

describe Bootstrap::ViewHelpers::NavBar do
  it {expect(helper).to render_with 'nav.navbar.navbar-default[@role="navigation"]'}
  it {expect(helper {|h| h.button}).to render_with 'nav > button.navbar-btn'}
  it {expect(helper {|h| h.text 'some text'}).to render_with 'nav > p.navbar-text', text: 'some text'}
  it {expect(helper).to have_enum :position}
  it {expect(helper :fixed_top).to render_with 'nav.navbar.navbar-fixed-top'}
  it {expect(helper).to have_enum(:type)}
  it {expect(helper :inverse).to render_with 'nav.navbar.navbar-inverse'}
  it {expect(helper).to have_safe_method :button, :text, :nav}
end