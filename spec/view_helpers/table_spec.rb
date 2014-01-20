require 'spec_helper'

describe BootstrapIt::ViewHelpers::Table do
  it { expect(helper.render).to have_tag 'table.table' }
  it { expect(helper(tag: 'div').render).to have_tag 'table.table' }

  %i(striped bordered hover condensed).each do |switch|
    it "has #{switch} switch" do
      expect(helper).to have_flag(switch)
        .with(html_class: ["table-#{switch}"])
    end
  end

  it { expect(helper).to have_flag(:responsive) }
  it 'wraps responsive tables' do
    expect(helper(:responsive).render).to have_tag(
      'div.table-responsive > table.table'
    )
  end

  it 'renders child rows' do
    expect(BootstrapIt::ViewHelpers::TableRow).to receive(:new).and_call_original
    helper.row
  end
end

describe BootstrapIt::ViewHelpers::TableRow do
  it { expect(helper.render).to have_tag 'tr' }
  it { expect(helper(tag: 'div').render).to have_tag 'tr' }

  it 'renders child cells' do
    expect(BootstrapIt::ViewHelpers::TableCell).to receive(:new)
      .and_call_original
    helper.cell
  end

  it 'renders child head cells' do
    expect(BootstrapIt::ViewHelpers::TableCell).to receive(:new)
      .and_call_original
    helper.head
  end

  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Contextual }
end

describe BootstrapIt::ViewHelpers::TableCell, type: :view do
  it { expect(helper.render).to have_tag 'td' }
  it { expect(helper(:th).render).to have_tag 'th' }
  it { expect(helper(:head).render).to have_tag 'th' }
  it { expect(helper(:header).render).to have_tag 'th' }
  it 'cleans up options' do
    expect(helper :th, :head, :header, th: true, head: true, header: true)
      .to_not have_option :th, :head, :header
  end
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::SizableColumn }
  it { expect(helper).to be_kind_of BootstrapIt::ViewHelpers::Contextual }
  it { expect(helper).to be_kind_of WrapIt::TextContainer }
end
