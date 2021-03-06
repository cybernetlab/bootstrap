require 'spec_helper'

# @TODO: dropdownwrapper testing

describe BootstrapIt::ViewHelpers::Contextual do
  it {expect(wrapper).to have_enum :state}
  it 'sets state class' do
    %i(active success warning danger).each do |state|
      @wrapper = nil
      expect(wrapper(state).render).to have_tag "div.#{state}"
      @wrapper = nil
      expect(wrapper(state: state).render).to have_tag "div.#{state}"
    end
  end
end

describe BootstrapIt::ViewHelpers::SizableColumn do
  # column_size_defined?
  it { expect(wrapper.column_size_defined?).to be_false }
  it 'detects if size defined' do
    %i(xs2 sm2 md2 lg2).each do |c|
      @wrapper = nil
      expect(wrapper(c).column_size_defined?).to be_true
    end
  end

  it 'sanitize extra small classes' do
    %i(col_xs_2 xs_2 xs2 extra_small_2 extrasmall2).each do |c|
      @wrapper = nil
      expect(wrapper(c).render).to have_tag 'div.col-xs-2'
      @wrapper = nil
      wrapper.column_size = c
      expect(wrapper.render).to have_tag 'div.col-xs-2'
    end
  end

  it 'sanitize small classes' do
    %i(col_sm_2 sm_2 sm2 small_2 small2).each do |c|
      @wrapper = nil
      expect(wrapper(c).render).to have_tag 'div.col-sm-2'
      @wrapper = nil
      wrapper.column_size = c
      expect(wrapper.render).to have_tag 'div.col-sm-2'
    end
  end

  it 'sanitize medium classes' do
    %i(col_md_2 md_2 md2 medium_2 medium2).each do |c|
      @wrapper = nil
      expect(wrapper(c).render).to have_tag 'div.col-md-2'
      @wrapper = nil
      wrapper.column_size = c
      expect(wrapper.render).to have_tag 'div.col-md-2'
    end
  end

  it 'sanitize large classes' do
    %i(col_lg_2 lg_2 lg2 large_2 large2).each do |c|
      @wrapper = nil
      expect(wrapper(c).render).to have_tag 'div.col-lg-2'
      @wrapper = nil
      wrapper.column_size = c
      expect(wrapper.render).to have_tag 'div.col-lg-2'
    end
  end

  it '#column_size= accepts sizes as array' do
    wrapper.column_size = [:xs_2, :md_4]
    expect(wrapper.render).to have_tag 'div.col-xs-2.col-md-4'
  end

  it 'omits second same size' do
    expect(wrapper(:sm3, :sm1).render).to have_tag 'div[@class="col-sm-3"]'
  end

  it 'combines differ size types' do
    expect(wrapper(:sm12, :lg1).render).to have_tag 'div.col-sm-12.col-lg-1'
  end
end

describe BootstrapIt::ViewHelpers::PlacableColumn do
  %w[offset push pull].each do |act|
    # column_[offset|push|pull]_defined?
    it { expect(wrapper.send "column_#{act}_defined?").to be_false }
    it { expect(wrapper.send "column_place_defined?").to be_false }
    it "detects if #{act} defined" do
      %I(xs_#{act}_2 sm_#{act}_2 md_#{act}_2 lg_#{act}_2).each do |c|
        @wrapper = nil
        expect(wrapper(c).send "column_#{act}_defined?").to be_true
        @wrapper = nil
        expect(wrapper(c).send "column_place_defined?").to be_true
      end
    end

    it "sanitize extra small #{act}" do
      %I(col_xs_#{act}_2 xs_#{act}_2 extra_small_#{act}_2
         extrasmall#{act}2).each do |c|
        @wrapper = nil
        expect(wrapper(c).render).to have_tag "div.col-xs-#{act}-2"
        @wrapper = nil
        wrapper.column_place = c
        expect(wrapper(c).render).to have_tag "div.col-xs-#{act}-2"
      end
    end

    it "sanitize small #{act}" do
      %I(col_sm_#{act}_2 sm_#{act}_2 sm#{act}2 small_#{act}_2
         small#{act}2).each do |c|
        @wrapper = nil
        expect(wrapper(c).render).to have_tag "div.col-sm-#{act}-2"
        @wrapper = nil
        wrapper.column_place = c
        expect(wrapper(c).render).to have_tag "div.col-sm-#{act}-2"
      end
    end

    it "sanitize medium #{act}" do
      %I(col_md_#{act}_2 md_#{act}_2 md#{act}2 medium_#{act}_2
         medium#{act}2).each do |c|
        @wrapper = nil
        expect(wrapper(c).render).to have_tag "div.col-md-#{act}-2"
        @wrapper = nil
        wrapper.column_place = c
        expect(wrapper(c).render).to have_tag "div.col-md-#{act}-2"
      end
    end

    it "sanitize large #{act}" do
      %I(col_lg_#{act}_2 lg_#{act}_2 lg#{act}2 large_#{act}_2
         large#{act}2).each do |c|
        @wrapper = nil
        expect(wrapper(c).render).to have_tag "div.col-lg-#{act}-2"
        @wrapper = nil
        wrapper.column_place = c
        expect(wrapper(c).render).to have_tag "div.col-lg-#{act}-2"
      end
    end
  end
end

describe BootstrapIt::ViewHelpers::Activable do
  it { expect(wrapper).to have_flag(:active).with(html_class: ['active']) }
end

describe BootstrapIt::ViewHelpers::Disableable do
  it { expect(wrapper).to have_flag(:disabled).with(aliases: [:disable]) }
  it { expect(wrapper.render).to_not have_tag '.disabled' }
  it { expect(wrapper(:disabled).render).to have_tag '.disabled' }
  it { expect(wrapper(tag: :button).render).to_not have_tag '[@disabled]' }

  it 'includes disabled attr to buttons' do
    expect(wrapper(:disabled, tag: :button).render).to have_tag '[@disabled]'
  end

  it 'avoid disabled class for buttons' do
    expect(wrapper(:disabled, tag: :button).render).to_not have_tag '.disabled'
  end
end

describe BootstrapIt::ViewHelpers::Sizable do
  it { expect(wrapper(:lg).render).to have_tag '.lg' }
  it { expect(wrapper(:large).render).to have_tag '.lg' }
  it { expect(wrapper(:sm).render).to have_tag '.sm' }
  it { expect(wrapper(:small).render).to have_tag '.sm' }
  it { expect(wrapper(:xs).render).to have_tag '.xs' }
  it { expect(wrapper(:extrasmall).render).to have_tag '.xs' }
  it { expect(wrapper(:extra_small).render).to have_tag '.xs' }
  it { expect(wrapper(size: :large).render).to have_tag '.lg' }
  it { expect(wrapper(:small, size: :large).render).to have_tag '.sm' }

  it 'adds class prefix' do
    wrapper_class.class_eval do
      html_class_prefix 'btn-'
    end
    @wrapper = nil
    expect(wrapper(:lg).render).to have_tag '.btn-lg'
    @wrapper = nil
    expect(wrapper(:btn_lg).render).to have_tag '.btn-lg'
    @wrapper = nil
    expect(wrapper(:btn_large).render).to have_tag '.btn-lg'
  end

  it { expect(wrapper size: 'value').to_not have_option :size }
end

describe BootstrapIt::ViewHelpers::Justifable do
  it { expect(wrapper).to have_flag :justified }
end
