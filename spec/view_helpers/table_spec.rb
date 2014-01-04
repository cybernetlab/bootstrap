require 'spec_helper'

describe Bootstrap::ViewHelpers::Table do
  it {expect(rendered).to have_selector 'table.table'}
  it {expect(rendered helper tag: 'div').to have_selector 'table.table'}
  it {expect(rendered helper class: :test).to have_selector 'table.test.table'}
  it {expect(rendered(helper(class: :test) {|g| '<i>text</i>'.html_safe})).to have_selector 'table.test.table > i'}

  it {expect(rendered helper :responsive).to have_selector 'div.table-responsive > table.table'}
  it {expect(rendered helper responsive: true).to have_selector 'div.table-responsive > table.table'}
  it {expect(helper responsive: true).to_not have_option :responsive}

  %i[striped bordered hover condensed].each do |style|
    it {expect(rendered helper style).to have_selector "table.table.table-#{style}"}
    it {expect(rendered helper style => true).to have_selector "table.table.table-#{style}"}
    it {expect(helper style => true).to_not have_option style}
  end

  it {expect(rendered helper border: true).to have_selector 'table.table.table-bordered'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::TableRow).to receive(:new).and_call_original
    helper.row
  end

  it {expect(helper_class.helper_names).to eq 'table'}
end

describe Bootstrap::ViewHelpers::TableRow do
  it {expect(rendered).to have_selector 'tr'}
  it {expect(rendered helper tag: 'div').to have_selector 'tr'}
  it {expect(rendered(helper {|g| '<i>text</i>'.html_safe})).to have_selector 'tr > i'}

  it 'renders child cells' do
    expect(Bootstrap::ViewHelpers::TableCell).to receive(:new).and_call_original
    helper.cell
  end

  it 'renders child head cells' do
    expect(Bootstrap::ViewHelpers::TableCell).to receive(:new).and_call_original
    helper.head
  end

  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Contextual}
  it {expect(helper_class.helper_names).to eq nil}
end

describe Bootstrap::ViewHelpers::TableCell, type: :view do
  it {expect(rendered).to have_selector 'td'}
  it {expect(rendered helper class: :test).to have_selector 'td.test'}
  it {expect(rendered(helper(class: :test) {|g| '<p></p>'.html_safe})).to have_selector 'td.test > p'}
  it {expect(rendered helper :th).to have_selector 'th'}
  it {expect(rendered helper :head).to have_selector 'th'}
  it {expect(rendered helper :header).to have_selector 'th'}
  it {expect(helper :th, :head, :header, th: true, head: true, header: true).to_not have_option :th, :head, :header}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Column}
  it {expect(helper_class.helper_names).to eq nil}
end