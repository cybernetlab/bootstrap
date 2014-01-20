require 'spec_helper'

describe BootstrapIt::ViewHelpers::Icon do
  it { expect(helper.render).to have_tag 'i.fa-asterisk' }
  it { expect(helper(:bell).render).to have_tag 'i.fa-bell' }
end
