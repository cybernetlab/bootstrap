require 'spec_helper'

describe Bootstrap::ViewHelpers::Grid do
  it {expect(rendered).to have_selector 'div.container'}
  it {expect(rendered helper class: :test).to have_selector 'div.container.test'}
  it {expect(rendered(helper(class: :test) {|g| '<p></p>'.html_safe})).to have_selector 'div.container.test > p'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  it {expect(described_class.helper_names).to eq 'grid'}
end

describe Bootstrap::ViewHelpers::GridRow do
  it {expect(rendered).to have_selector 'div.row'}
  it {expect(rendered helper class: :test).to have_selector 'div.row.test'}
  it {expect(rendered(helper(class: :test) {|g| '<p></p>'.html_safe})).to have_selector 'div.row.test > p'}

  it 'renders child cells' do
    expect(Bootstrap::ViewHelpers::GridCell).to receive(:new).and_call_original
    helper.cell
  end

  it {expect(helper.clear).to have_selector 'div.clearfix.visible-md'}
  it {expect(helper.clear :hidden_large).to have_selector 'div.clearfix.hidden-lg'}

  it {expect(described_class.helper_names).to eq nil}
end

describe Bootstrap::ViewHelpers::GridCell do
  it {expect(rendered).to have_selector 'div.col-md-3'}
  it {expect(rendered helper class: :test).to have_selector 'div.col-md-3.test'}
  it {expect(rendered(helper(class: :test) {|g| '<p></p>'.html_safe})).to have_selector 'div.col-md-3.test > p'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  %w[offset push pull].each do |act|
    it "sanitize extra small #{act}" do
      %W[col-xs-#{act}-2 xs-#{act}-2 xs_#{act}_2 xs-#{act}-2 extra-small-#{act}-2 extra_small_#{act}_2 extrasmall#{act}2].each do |c|
        @helper = nil
        expect(rendered helper c).to have_selector "div.col-xs-#{act}-2"
      end
    end
  
    it "sanitize small #{act}" do
      %W[col-sm-#{act}-2 sm-#{act}-2 sm_#{act}_2 sm#{act}2 small-#{act}-2 small_#{act}_2 small#{act}2].each do |c|
        @helper = nil
        expect(rendered helper c).to have_selector "div.col-sm-#{act}-2"
      end
    end
  
    it "sanitize medium #{act}" do
      %W[col-md-#{act}-2 md-#{act}-2 md_#{act}_2 md#{act}2 medium-#{act}-2 medium_#{act}_2 medium#{act}2].each do |c|
        @helper = nil
        expect(rendered helper c).to have_selector "div.col-md-#{act}-2"
      end
    end
  
    it "sanitize large #{act}" do
      %W[col-lg-#{act}-2 lg-#{act}-2 lg_#{act}_2 lg#{act}2 large-#{act}-2 large_#{act}_2 large#{act}2].each do |c|
        @helper = nil
        expect(rendered helper c).to have_selector "div.col-lg-#{act}-2"
      end
    end
  end

  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Column}
  it {expect(described_class.helper_names).to eq nil}
end