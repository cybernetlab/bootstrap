require 'spec_helper'

# @TODO: dropdownwrapper testing

describe Bootstrap::ViewHelpers::Contextual do
  %w[active success warning danger].each do |state|
    it "sets #{state} class throw arg" do
      expect(rendered wrapper state).to have_selector "div.#{state}"
    end
    it "sets #{state} class throw hash" do
      expect(rendered wrapper state => true).to have_selector "div.#{state}"
    end
    it "remove #{state} from options" do
      expect(wrapper state => true).to_not have_option state.to_sym
    end
  end

  it {expect(rendered wrapper :active, :warning).to have_selector 'div[@class="active"]'}
  it {expect(rendered wrapper :warning, danger: true).to have_selector 'div[@class="warning"]'}
end

describe Bootstrap::ViewHelpers::Column do
  it 'sanitize extra small classes' do
    %w[col-xs-2 xs-2 xs_2 xs2 extra-small-2 extra_small_2 extrasmall2 XS-2 ExtraSmall2].each do |c|
      @wrapper = nil; expect(rendered wrapper c).to have_selector 'div.col-xs-2'
    end
  end

  it 'sanitize small classes' do
    %w[col-sm-2 sm-2 sm_2 sm2 small-2 small_2 small2].each do |c|
      @wrapper = nil; expect(rendered wrapper c).to have_selector 'div.col-sm-2'
    end
  end

  it 'sanitize medium classes' do
    %w[col-md-2 md-2 md_2 md2 medium-2 medium_2 medium2].each do |c|
      @wrapper = nil; expect(rendered wrapper c).to have_selector 'div.col-md-2'
    end
  end

  it 'sanitize large classes' do
    %w[col-lg-2 lg-2 lg_2 lg2 large-2 large_2 large2].each do |c|
      @wrapper = nil; expect(rendered wrapper c).to have_selector 'div.col-lg-2'
    end
  end

  it {expect(rendered wrapper :sm3, :sm1).to have_selector 'div[@class="col-sm-3"]'}
  it {expect(rendered wrapper :sm12, :lg1).to have_selector 'div.col-sm-12.col-lg-1'}
end

describe Bootstrap::ViewHelpers::Activable do
  it {expect(rendered wrapper).to_not have_selector '.active'}
  it {expect(rendered wrapper active: true).to have_selector '.active'}
  it {expect(rendered wrapper :active).to have_selector '.active'}
  it {expect(wrapper active: true).to_not have_option :active}
  it {expect(wrapper active: false).to_not have_option :active}
end

describe Bootstrap::ViewHelpers::Disableable do
  it {expect(rendered wrapper).to_not have_selector '.disabled'}
  it {expect(rendered wrapper disabled: true).to have_selector '.disabled'}
  it {expect(rendered wrapper :disabled).to have_selector '.disabled'}
  it {expect(rendered wrapper tag: :button).to_not have_selector '[@disabled]'}
  it {expect(rendered wrapper tag: :button).to_not have_selector '.disabled'}
  it {expect(rendered wrapper tag: :button, disabled: true).to have_selector '[@disabled]'}
  it {expect(rendered wrapper tag: :button, disabled: true).to_not have_selector '.disabled'}
  it {expect(rendered wrapper :disabled, tag: :button).to have_selector '[@disabled]'}
  it {expect(rendered wrapper :disabled, tag: :button).to_not have_selector '.disabled'}
  it {expect(wrapper disable: true, disabled: true).to_not have_option :disable, :disabled}
  it {expect(wrapper disable: false, disabled: false).to_not have_option :disable, :disabled}
  it {expect(wrapper disable: true, disabled: false).to_not have_option :disable, :disabled}
end

describe Bootstrap::ViewHelpers::Sizable do
  it {expect(rendered wrapper :lg).to have_selector ".lg"}
  it {expect(rendered wrapper :large).to have_selector ".lg"}
  it {expect(rendered wrapper :sm).to have_selector ".sm"}
  it {expect(rendered wrapper :small).to have_selector ".sm"}
  it {expect(rendered wrapper :xs).to have_selector ".xs"}
  it {expect(rendered wrapper :extrasmall).to have_selector ".xs"}
  it {expect(rendered wrapper :extra_small).to have_selector ".xs"}
  it {expect(rendered wrapper 'extra-small').to have_selector ".xs"}
  it {expect(rendered wrapper size: :large).to have_selector ".lg"}
  it {expect(rendered wrapper :small, size: :large).to have_selector ".sm"}
  it 'adds class prefix' do
    with_wrapper_class do
      self.class_prefix = 'btn'
    end
    expect(rendered wrapper :lg).to have_selector '.btn-lg'
    expect(rendered wrapper :btn_lg).to have_selector '.btn-lg'
    expect(rendered wrapper :btn_large).to have_selector '.btn-lg'
  end
  it {expect(wrapper size: 'value').to_not have_option :size}
end

describe Bootstrap::ViewHelpers::Justifable do
  it {expect(rendered wrapper).to_not have_selector '.justified'}
  it {expect(rendered wrapper justify: true).to have_selector '.justified'}
  it {expect(rendered wrapper justified: true).to have_selector '.justified'}
  it {expect(rendered wrapper :justify).to have_selector '.justified'}
  it {expect(rendered wrapper :justified).to have_selector '.justified'}
  it 'adds class prefix' do
    with_wrapper_class do
      self.class_prefix = 'btn'
    end
    expect(rendered wrapper :justified).to have_selector '.btn-justified'
  end
  it {expect(wrapper justified: true, justify: false).to_not have_option :justified}
  it {expect(wrapper justified: :none).to_not have_option :justified}
end
