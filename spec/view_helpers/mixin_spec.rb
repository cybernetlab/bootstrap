require 'spec_helper'

# @TODO: dropdownwrapper testing

describe Bootstrap::ViewHelpers::Contextual do
  it {expect(wrapper).to have_enum :state}
  it 'sets state class' do
    %i[active success warning danger].each do |state|
      @wrapper = nil; expect(wrapper state).to render_with "div.#{state}"
      @wrapper = nil; expect(wrapper state: state).to render_with "div.#{state}"
    end
  end
end

describe Bootstrap::ViewHelpers::Column do
  it 'sanitize extra small classes' do
    %w[col-xs-2 xs-2 xs_2 xs2 extra-small-2 extra_small_2 extrasmall2 XS-2 ExtraSmall2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-xs-2'
    end
  end

  it 'sanitize small classes' do
    %w[col-sm-2 sm-2 sm_2 sm2 small-2 small_2 small2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-sm-2'
    end
  end

  it 'sanitize medium classes' do
    %w[col-md-2 md-2 md_2 md2 medium-2 medium_2 medium2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-md-2'
    end
  end

  it 'sanitize large classes' do
    %w[col-lg-2 lg-2 lg_2 lg2 large-2 large_2 large2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-lg-2'
    end
  end

  it {expect(wrapper :sm3, :sm1).to render_with 'div[@class="col-sm-3"]'}
  it {expect(wrapper :sm12, :lg1).to render_with 'div.col-sm-12.col-lg-1'}
end

describe Bootstrap::ViewHelpers::Activable do
  it {expect(wrapper).to have_flag :active}
  it {expect(wrapper).to_not render_with '.active'}
  it {expect(wrapper :active).to render_with '.active'}
end

describe Bootstrap::ViewHelpers::Disableable do
  it {expect(wrapper).to have_flag :disabled}
  it {expect(wrapper).to_not render_with '.disabled'}
  it {expect(wrapper :disabled).to render_with '.disabled'}
  it {expect(wrapper tag: :button).to_not render_with '[@disabled]'}
  it {expect(wrapper :disabled, tag: :button).to render_with '[@disabled]'}
  it {expect(wrapper :disabled, tag: :button).to_not render_with '.disabled'}
end

describe Bootstrap::ViewHelpers::Sizable do
  it {expect(wrapper :lg).to render_with ".lg"}
  it {expect(wrapper :large).to render_with ".lg"}
  it {expect(wrapper :sm).to render_with ".sm"}
  it {expect(wrapper :small).to render_with ".sm"}
  it {expect(wrapper :xs).to render_with ".xs"}
  it {expect(wrapper :extrasmall).to render_with ".xs"}
  it {expect(wrapper :extra_small).to render_with ".xs"}
  it {expect(wrapper 'extra-small').to render_with ".xs"}
  it {expect(wrapper size: :large).to render_with ".lg"}
  it {expect(wrapper :small, size: :large).to render_with ".sm"}
  it 'adds class prefix' do
    wrapper_class.class_eval do
      self.class_prefix = 'btn'
    end
    @wrapper = nil; expect(wrapper :lg).to render_with '.btn-lg'
    @wrapper = nil; expect(wrapper :btn_lg).to render_with '.btn-lg'
    @wrapper = nil; expect(wrapper :btn_large).to render_with '.btn-lg'
  end
  it {expect(wrapper size: 'value').to_not have_option :size}
end

describe Bootstrap::ViewHelpers::Justifable do
  it {expect(wrapper).to have_flag :justified}
  it {expect(wrapper).to_not render_with '.justified'}
  it {expect(wrapper :justified).to render_with '.justified'}
  it 'adds class prefix' do
    wrapper_class.class_eval {self.class_prefix = 'btn'}
    expect(wrapper :justified).to render_with '.btn-justified'
  end
end
