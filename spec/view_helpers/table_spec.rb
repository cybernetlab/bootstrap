require 'spec_helper'

describe Bootstrap::ViewHelpers::Table do
  it {expect(rendered).to have_selector 'table.table'}
  it {expect(rendered helper tag: 'div').to have_selector 'table.table'}
  it {expect(rendered helper class: :test).to have_selector 'table.test.table'}
  it {expect(rendered(helper(class: :test) {|g| '<i>text</i>'.html_safe})).to have_selector 'table.test.table > i'}

  it {expect(rendered helper :responsive).to have_selector 'div.table-responsive > table.table'}
  it {expect(rendered helper responsive: true).to have_selector 'div.table-responsive > table.table'}

  it {expect(rendered helper :striped).to have_selector 'table.table.table-striped'}
  it {expect(rendered helper striped: true).to have_selector 'table.table.table-striped'}

  it {expect(rendered helper :bordered).to have_selector 'table.table.table-bordered'}
  it {expect(rendered helper bordered: true).to have_selector 'table.table.table-bordered'}
  it {expect(rendered helper border: true).to have_selector 'table.table.table-bordered'}

  it {expect(rendered helper :hover).to have_selector 'table.table.table-hover'}
  it {expect(rendered helper hover: true).to have_selector 'table.table.table-hover'}

  it {expect(rendered helper :condensed).to have_selector 'table.table.table-condensed'}
  it {expect(rendered helper condensed: true).to have_selector 'table.table.table-condensed'}

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
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Column}
  it {expect(helper_class.helper_names).to eq nil}
end