require 'spec_helper'

describe Bootstrap::ViewHelpers::Grid do
  it {expect(helper).to render_with 'div.container'}
  it {expect(helper class: :test).to render_with 'div.container.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'div.container.test > p'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  # method returns safety
  it {expect(helper).to have_safe_method :row}

  it {expect(described_class.helper_names).to eq 'grid'}
end

describe Bootstrap::ViewHelpers::GridRow do
  it {expect(helper).to render_with 'div.row'}
  it {expect(helper class: :test).to render_with 'div.row.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'div.row.test > p'}

  it 'renders child cells' do
    expect(Bootstrap::ViewHelpers::GridCell).to receive(:new).and_call_original
    helper.cell
  end

  it {expect(helper {|h| h.clear}).to render_with 'div.row > div.clearfix.visible-md'}
  it {expect(helper {|h| h.clear :hidden_large}).to render_with 'div.row > div.clearfix.hidden-lg'}

  # method returns safety
  it {expect(helper).to have_safe_method :cell, :clear}

  it {expect(described_class.helper_names).to eq nil}
end

describe Bootstrap::ViewHelpers::GridCell do
  it {expect(helper).to render_with 'div.col-md-3'}
  it {expect(helper class: :test).to render_with 'div.col-md-3.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'div.col-md-3.test > p'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::GridRow).to receive(:new).and_call_original
    helper.row
  end

  # method returns safety
  it {expect(helper).to have_safe_method :row}

  %w[offset push pull].each do |act|
    it "sanitize extra small #{act}" do
      %W[col-xs-#{act}-2 xs-#{act}-2 xs_#{act}_2 xs-#{act}-2 extra-small-#{act}-2 extra_small_#{act}_2 extrasmall#{act}2].each do |c|
        @helper = nil
        expect(helper c).to render_with "div.col-xs-#{act}-2"
      end
    end
  
    it "sanitize small #{act}" do
      %W[col-sm-#{act}-2 sm-#{act}-2 sm_#{act}_2 sm#{act}2 small-#{act}-2 small_#{act}_2 small#{act}2].each do |c|
        @helper = nil
        expect(helper c).to render_with "div.col-sm-#{act}-2"
      end
    end
  
    it "sanitize medium #{act}" do
      %W[col-md-#{act}-2 md-#{act}-2 md_#{act}_2 md#{act}2 medium-#{act}-2 medium_#{act}_2 medium#{act}2].each do |c|
        @helper = nil
        expect(helper c).to render_with "div.col-md-#{act}-2"
      end
    end
  
    it "sanitize large #{act}" do
      %W[col-lg-#{act}-2 lg-#{act}-2 lg_#{act}_2 lg#{act}2 large-#{act}-2 large_#{act}_2 large#{act}2].each do |c|
        @helper = nil
        expect(helper c).to render_with "div.col-lg-#{act}-2"
      end
    end
  end

  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Column}
  it {expect(described_class.helper_names).to eq nil}
end