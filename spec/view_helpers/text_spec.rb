require 'spec_helper'

describe BootstrapIt::ViewHelpers::Label do
  it { expect(helper.render).to have_tag 'span.label.label-default' }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }
  it { expect(helper).to have_enum :appearence }
  it { expect(helper(:danger).render).to have_tag 'span.label.label-danger' }
end

describe BootstrapIt::ViewHelpers::Badge do
  it { expect(helper.render).to have_tag 'span.badge' }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }
end
