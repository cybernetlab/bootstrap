require 'spec_helper'

describe Bootstrap::ViewHelpers::Table do
  it {expect(helper).to render_with 'table.table'}
  it {expect(helper tag: 'div').to render_with 'table.table'}
  it {expect(helper class: :test).to render_with 'table.test.table'}
  it {expect(helper(class: :test) {|g| '<i>text</i>'.html_safe}).to render_with 'table.test.table > i'}

  it {expect(helper).to have_flag(:striped).with(html_class: 'table-striped')}
  it {expect(helper).to have_flag(:bordered).with(html_class: 'table-bordered')}
  it {expect(helper).to have_flag(:hover).with(html_class: 'table-hover')}
  it {expect(helper).to have_flag(:condensed).with(html_class: 'table-condensed')}
  it {expect(helper).to have_flag(:responsive)}
  it {expect(helper :responsive).to render_with 'div.table-responsive > table.table'}

  it 'renders child rows' do
    expect(Bootstrap::ViewHelpers::TableRow).to receive(:new).and_call_original
    helper.row
  end
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
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Contextual}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::TextContainer}
end