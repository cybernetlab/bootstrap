require 'spec_helper'

describe Bootstrap::ViewHelpers::Jumbotron do
  it { expect(helper).to render_with 'div.jumbotron' }

  # full_width
  it { expect(helper).to have_flag :full_width }
  it 'makes full width jumbotron' do
    expect(helper :full_width).to render_with 'div.jumbotron > div.container'
  end
end

describe Bootstrap::ViewHelpers::PageHeader do
  it { expect(helper).to render_with 'div.page-header' }
end

describe Bootstrap::ViewHelpers::Alert do
  it { expect(helper).to render_with 'div.alert.alert-success' }

  # behaviour
  it { expect(helper).to be_kind_of WrapIt::TextContainer }

  # appearence
  it 'has appearence enum' do
    expect(helper).to have_enum(:appearence).with(
      values: %i(success info warning danger),
      default: :success,
      html_class_prefix: 'alert-'
    )
  end

  # dismissable
  it 'has dismissable switch' do
    expect(helper).to have_flag(:dismissable)
      .with(html_class: ['alert-dismissable'])
  end
  it 'renders dismissable alert with button' do
    expect(helper(:dismissable, 'Some text')).to render_with(
      'div.alert.alert-success.alert-dismissable[text()="Some text"]' \
      ' > button.close[@type="button"][@data-dismiss="alert"]' \
      '[@aria-hidden="true"]'
    )
  end

  # links
  it 'renders link with alert-link class' do
    expect(helper { |h| h.link 'test', 'url' }).to render_with(
      'div.alert.alert-success' \
      ' > a.alert-link[@href="url"][text()="test"]'
    )
  end

  it { expect(helper.class.html_class_prefix).to eq 'alert-' }
end

describe Bootstrap::ViewHelpers::ProgressBar do
  it 'renders with all needed atrributes' do
    expect(helper).to render_with(
      'div.progress-bar[@role="progressbar"][@aria-valuenow="0"]' \
      '[@aria-valuemin="0"][@aria-valuemax="100"][@style="width: 0%"]' \
      ' > span.sr-only[text()="0% Complete"]'
    )
  end

  # custom text
  it 'renders with custom text' do
    expect(helper('custom text')).to render_with(
      'div.progress-bar > span.sr-only[text()="custom text"]'
    )
  end

  # complete
  it 'accepts integer arguments as complete percents' do
    expect(helper(60)).to render_with(
      'div.progress-bar[@aria-valuenow="60"][@style="width: 60%"]' \
      ' > span.sr-only[text()="60% Complete"]'
    )
  end

  # behaviour
  it { expect(helper).to be_kind_of WrapIt::TextContainer }

  # appearence
  it 'has appearence enum' do
    expect(helper).to have_enum(:appearence).with(
      values: %i(success info warning danger),
      html_class_prefix: 'progress-bar-'
    )
  end
end

describe Bootstrap::ViewHelpers::Progress do
  it 'renders with all needed atrributes' do
    expect(helper).to render_with(
      'div.progress > div.progress-bar[@role="progressbar"]' \
      '[@aria-valuenow="0"][@aria-valuemin="0"][@aria-valuemax="100"]' \
      '[@style="width: 0%"] > span.sr-only[text()="0% Complete"]'
    )
  end

  # behaviour
  it { expect(helper).to be_kind_of Bootstrap::ViewHelpers::Activable }

  # striped
  it 'has striped switch' do
    expect(helper).to have_flag(:striped)
      .with(html_class: ['progress-striped'])
  end

  # second bar
  it 'renders second bar' do
    expect(helper(10) { |h| h.bar 30 }).to render_with(
      'div.progress > div.progress-bar[@aria-valuenow="10"]' \
      ' + div.progress-bar[@aria-valuenow="30"]'
    )
  end
end
