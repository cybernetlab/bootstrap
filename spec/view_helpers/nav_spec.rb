require 'spec_helper'

describe BootstrapIt::ViewHelpers::Nav do
  it { expect(helper.render).to have_tag 'ul.nav' }

  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Justifable }
  it { expect(helper).to be_kind_of WrapIt::Base }

  it 'renders active links' do
    expect(helper { |h| h.link_item :active }.render).to have_tag(
      'ul > li.active'
    )
  end

  it 'renders dropdowns' do
    expect(
      helper { |h| h.dropdown('text') { |d| d.header 'header' } }.render
    ).to have_tag(
      'ul > li.dropdown' \
      ' > a.dropdown-toggle[@data-toggle="dropdown"]' \
      '[@href="#"][text()="text "]'
    )
  end
end

describe BootstrapIt::ViewHelpers::NavPills do
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Nav }
  it { expect(helper.render).to have_tag 'ul.nav.nav-pills' }
end

describe BootstrapIt::ViewHelpers::NavTabs do
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Nav }
  it { expect(helper.render).to have_tag 'ul.nav.nav-tabs' }
end

describe BootstrapIt::ViewHelpers::NavBar do
  it 'renders with all needed options' do
    expect(helper.render).to have_tag(
      'nav.navbar.navbar-default[@role="navigation"]'
    )
  end

  it 'renders with button' do
    expect(helper { |h| h.button }.render).to have_tag(
      'nav > button.navbar-btn'
    )
  end

  it 'renders with text' do
    expect(helper { |h| h.text 'some text' }.render).to have_tag(
      'nav > p.navbar-text', text: 'some text'
    )
  end

  it 'has position enum' do
    expect(helper).to have_enum(:position)
      .with(values: %i(fixed-top fixed-bottom static-top),
            html_class_prefix: 'navbar-')
  end

  it 'has type enum' do
    expect(helper).to have_enum(:type)
      .with(values: %i[default inverse],
            default: :default,
            html_class_prefix: 'navbar-')
  end
end
