require 'spec_helper'

describe Bootstrap::ViewHelpers::Label do
  it { expect(helper).to render_with 'span.label.label-default' }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }
  it { expect(helper).to have_enum :appearence }
  it { expect(helper :danger).to render_with 'span.label.label-danger' }
end

describe Bootstrap::ViewHelpers::Badge do
  it { expect(helper).to render_with 'span.badge' }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }
end
