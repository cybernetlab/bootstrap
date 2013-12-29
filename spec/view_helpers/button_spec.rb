require 'spec_helper'

describe Bootstrap::ViewHelpers::Button do
  it {expect(rendered).to have_selector 'button.btn.btn-default[@type="button"]'}
  it {expect(rendered helper type: 'submit').to have_selector 'button.btn.btn-default[@type="submit"]'}
  it {expect(rendered helper tag: :a).to have_selector 'a.btn.btn-default[@role="button"]'}
  it {expect(rendered helper tag: :input).to have_selector 'input.btn.btn-default[@type="button"]'}
  it {expect(rendered helper tag: :input, type: :submit).to have_selector 'input.btn.btn-default[@type="submit"]'}
  it {expect(rendered helper tag: :p).to have_selector 'button.btn.btn-default'}
  it {expect(rendered helper class: :test).to have_selector 'button.btn.btn-default.test'}
  it {expect(rendered(helper(class: :test) {|g| '<p></p>'.html_safe})).to have_selector 'button.btn.btn-default.test > p'}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Activable}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Disableable}
  it {expect(helper_class.helper_names).to eq 'button'}

  # types
  %i[default primary success info warning danger link].each do |type|
    it {expect(rendered helper type).to have_selector "button.btn.btn-#{type}"}
  end

  # sizes
  it {expect(rendered helper :lg).to have_selector "button.btn.btn-lg"}
  it {expect(rendered helper :large).to have_selector "button.btn.btn-lg"}
  it {expect(rendered helper :sm).to have_selector "button.btn.btn-sm"}
  it {expect(rendered helper :small).to have_selector "button.btn.btn-sm"}
  it {expect(rendered helper :xs).to have_selector "button.btn.btn-xs"}
  it {expect(rendered helper :extrasmall).to have_selector "button.btn.btn-xs"}
  it {expect(rendered helper :extra_small).to have_selector "button.btn.btn-xs"}
  it {expect(rendered helper 'extra-small').to have_selector "button.btn.btn-xs"}
  it {expect(rendered helper size: :large).to have_selector "button.btn.btn-lg"}
  it {expect(rendered helper :small, size: :large).to have_selector "button.btn.btn-sm"}

  it {expect(rendered helper :block).to have_selector "button.btn.btn-block"}
  it {expect(rendered helper block: true).to have_selector "button.btn.btn-block"}
end

