require 'spec_helper'

describe Bootstrap::ViewHelpers::Jumbotron do
  it {expect(helper).to render_with 'div.jumbotron'}

  # full_width
  it {expect(helper).to have_flag :full_width}
  it {expect(helper :full_width).to render_with 'div.jumbotron > div.container'}
end

describe Bootstrap::ViewHelpers::PageHeader do
  it {expect(helper).to render_with 'div.page-header'}
end

describe Bootstrap::ViewHelpers::Alert do
  it {expect(helper).to render_with 'div.alert.alert-success'}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::TextContainer}

  # method returns safety
  it {expect(helper).to have_safe_method :link}

  # appearence
  it {expect(helper).to have_enum :appearence}
  it 'supports many appearences' do
    %i[success info warning danger].each do |type|
      @helper = nil; expect(helper type).to render_with "div.alert.alert-#{type}"
      @helper = nil; expect(helper appearence: type).to render_with "div.alert.alert-#{type}"
    end
  end

  # dismissable
  it {expect(helper).to have_flag :dismissable}
  it {expect(helper :dismissable, 'Some text').to render_with 'div.alert.alert-success.alert-dismissable[text()="Some text"] > button.close[@type="button"][@data-dismiss="alert"][@aria-hidden="true"]'}

  # links
  it {expect(helper {|h| h.link 'test', 'http://url'}).to render_with 'div.alert.alert-success > a.alert-link[@href="http://url"][text()="test"]'}
end

describe Bootstrap::ViewHelpers::ProgressBar do
  it {expect(helper).to render_with 'div.progress-bar[@role="progressbar"][@aria-valuenow="0"][@aria-valuemin="0"][@aria-valuemax="100"][@style="width: 0%"] > span.sr-only[text()="0% Complete"]'}

  # custom text
  it {expect(helper 'custom text').to render_with 'div.progress-bar > span.sr-only[text()="custom text"]'}

  # complete
  it {expect(helper 60).to render_with 'div.progress-bar[@aria-valuenow="60"][@style="width: 60%"] > span.sr-only[text()="60% Complete"]'}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::TextContainer}

  # appearence
  it {expect(helper).to have_enum :appearence}
  it 'supports many appearences' do
    %i[success info warning danger].each do |type|
      @helper = nil; expect(helper type).to render_with "div.progress-bar-#{type}"
      @helper = nil; expect(helper appearence: type).to render_with "div.progress-bar-#{type}"
    end
  end
end

describe Bootstrap::ViewHelpers::Progress do
  it {expect(helper).to render_with 'div.progress > div.progress-bar[@role="progressbar"][@aria-valuenow="0"][@aria-valuemin="0"][@aria-valuemax="100"][@style="width: 0%"] > span.sr-only[text()="0% Complete"]'}

  # behaviour
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Activable}

  # method returns safety
  it {expect(helper).to have_safe_method :bar}

  # striped
  it {expect(helper).to have_flag(:striped).with(html_class: 'progress-striped')}

  # second bar
  it {expect(helper(10) {|h| h.bar 30}).to render_with 'div.progress > div.progress-bar[@aria-valuenow="10"] + div.progress-bar[@aria-valuenow="30"]'}
end