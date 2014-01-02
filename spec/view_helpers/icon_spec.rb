require 'spec_helper'

describe Bootstrap::ViewHelpers::Icon do
  it {expect(rendered).to have_selector 'i.fa-asterisk'}
  it {expect(rendered helper :bell).to have_selector 'i.fa-bell'}
  it {expect(helper_class.helper_names).to eq ['icon', 'i']}
end