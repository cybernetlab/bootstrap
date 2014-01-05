require 'spec_helper'

describe Bootstrap::ViewHelpers::Table do
  it {expect(helper).to render_with 'table.table'}
  it {expect(helper tag: 'div').to render_with 'table.table'}
  it {expect(helper class: :test).to render_with 'table.test.table'}
  it {expect(helper(class: :test) {|g| '<i>text</i>'.html_safe}).to render_with 'table.test.table > i'}

  it {expect(helper :responsive).to render_with 'div.table-responsive > table.table'}
  it {expect(helper responsive: true).to render_with 'div.table-responsive > table.table'}
  it {expect(helper responsive: true).to_not have_option :responsive}

  %i[striped bordered hover condensed].each do |style|
    it {expect(helper style).to render_with "table.table.table-#{style}"}
    it {expect(helper style => true).to render_with "table.table.table-#{style}"}
    it {expect(helper style => true).to_not have_option style}
  end

  it {expect(helper border: true).to render_with 'table.table.table-bordered'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::TableRow).to receive(:new).and_call_original
    helper.row
  end

  it {expect(described_class.helper_names).to eq 'table'}
end

describe Bootstrap::ViewHelpers::TableRow do
  it {expect(helper).to render_with 'tr'}
  it {expect(helper tag: 'div').to render_with 'tr'}
  it {expect(helper {|g| '<i>text</i>'.html_safe}).to render_with 'tr > i'}

  it 'renders child cells' do
    expect(Bootstrap::ViewHelpers::TableCell).to receive(:new).and_call_original
    helper.cell
  end

  it 'renders child head cells' do
    expect(Bootstrap::ViewHelpers::TableCell).to receive(:new).and_call_original
    helper.head
  end

  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Contextual}
  it {expect(described_class.helper_names).to eq nil}
end

describe Bootstrap::ViewHelpers::TableCell, type: :view do
  it {expect(helper).to render_with 'td'}
  it {expect(helper class: :test).to render_with 'td.test'}
  it {expect(helper(class: :test) {|g| '<p></p>'.html_safe}).to render_with 'td.test > p'}
  it {expect(helper :th).to render_with 'th'}
  it {expect(helper :head).to render_with 'th'}
  it {expect(helper :header).to render_with 'th'}
  it {expect(helper :th, :head, :header, th: true, head: true, header: true).to_not have_option :th, :head, :header}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Column}
  it {expect(described_class.helper_names).to eq nil}
end