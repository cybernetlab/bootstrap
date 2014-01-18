require 'spec_helper'

describe BootstrapIt::ViewHelpers::Icon do
  it { expect(helper).to render_with 'i.fa-asterisk' }
  it { expect(helper :bell).to render_with 'i.fa-bell' }
end
