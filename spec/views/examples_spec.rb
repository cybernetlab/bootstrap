require 'spec_helper'

describe 'examples for README.md' do
  it 'renders grid example' do
    render inline: <<-HAML
      <%= grid do |g|
        g.row do |r|
          r.cell :md4, 'col 1'
          r.cell :md4, :md_offset_4, 'col 2'
        end
        g.row do |r|
          r.cell :md6, :md_offset_3, 'col 3'
          r.clear
        end
      end %>
    HAML
    expect(rendered).to have_tag 'div.container > div.row > div.col-md-4[text()="col 1"] + div.col-md-4.col-md-offset-4[text()="col 2"]'
    expect(rendered).to have_tag 'div.container > div.row > div.col-md-6.col-md-offset-3[text()="col 3"] + div.clearfix.visible-md'
  end

  it 'renders table example' do
    render inline: <<-HAML
      <%= table :condensed, :bordered do |t|
        t.row :success do |r|
          r.head 'header 1'
          r.head 'header 2'
        end
        t.row do |r|
          r.cell 'data', colspan: 2
        end
      end %>
    HAML
    expect(rendered).to have_tag 'table.table.table-condensed.table-bordered > tr.success > th[text()="header 1"] + th[text()="header 2"]'
    expect(rendered).to have_tag 'table > tr > td[@colspan="2"][text()="data"]'
  end

  it 'renders button example' do
    render inline: <<-HAML
      <%= button :danger, :large, 'alert', icon: 'home' %>
    HAML
    expect(rendered).to have_tag(
      'button.btn.btn-danger[@type="button"][text()=" alert"] > i.fa.fa-home'
    )
  end

  it 'renders icon example' do
    render inline: <<-HAML
      <%= icon :asterisk %>
    HAML
    #puts "*** #{rendered}"
    expect(rendered).to have_tag 'i.fa.fa-asterisk'
  end

  it 'renders button-group example #1' do
    render inline: <<-HAML
      <%= button_group do |g|
        g.button 'one'
        g.button 'two', :success
        g.dropdown 'dropdown' do |d|
          d.link_item 'link 1', '#'
          d.link_item 'link 2', '#'
        end
      end %>
    HAML
    expect(rendered).to have_tag(
      'div.btn-group > button.btn.btn-default[@type="button"][text()="one"]' \
      ' + button.btn.btn-success[@type="button"][text()="two"]'
    )
    expect(rendered).to have_tag(
      'div.btn-group > button.btn.btn-success[@type="button"][text()="two"]' \
      ' + div.btn-group > button.btn.btn-default.dropdown-toggle' \
      '[@data-toggle="dropdown"][@type="button"][text()="dropdown "]' \
      ' > span.caret'
    )
    expect(rendered).to have_tag(
      'div.btn-group > button.btn.btn-success[@type="button"][text()="two"]' \
      ' + div.btn-group > button + ul.dropdown-menu[@role="menu"]' \
      ' > li[@role="presentation"]' \
      ' + li > a[@role="menuitem"][@tabindex="-1"][text()="link 2"]'
    )
  end

  it 'renders button-group example #2' do
    render inline: <<-HAML
      <%= button_group do |g|
        g.radio 'radio 1', :primary
        g.radio 'radio 2', :primary
      end %>
    HAML
    expect(rendered).to have_tag 'div.btn-group[@data-toggle="buttons"] > label.btn.btn-primary[text()="radio 1"] > input[@type="radio"]'
    expect(rendered).to have_tag 'div.btn-group > label.btn.btn-primary[text()="radio 1"] + label.btn.btn-primary[text()="radio 2"] > input[@type="radio"]'
  end

  it 'renders dropdown button example' do
    render inline: <<-HAML
      <%= dropdown_button :danger, :splitted, 'Button' do |b|
        b.header 'Actions'
        b.link_item 'Action', '#'
        b.link_item 'Another action', '#'
        b.divider
      end %>
    HAML
    expect(rendered).to have_tag(
      'div.btn-group' \
      ' > button.btn.btn-danger[@type="button"][text()="Button"]' \
      ' + button.btn.btn-danger.dropdown-toggle[@type="button"]' \
      '[@data-toggle="dropdown"] > span.caret'
    )
    expect(rendered).to have_tag(
      'div.btn-group > button[@data-toggle="dropdown"]' \
      ' + ul.dropdown-menu[@role="menu"]' \
      ' > li.dropdown-header[text()="Actions"][@role="presentation"]'
    )
    expect(rendered).to have_tag(
      'div.btn-group > button + ul > li.dropdown-header' \
      ' + li[@role="presentation"]' \
      ' > a[@href="#"][text()="Action"][@role="menuitem"][@tabindex="-1"]'
    )
    expect(rendered).to have_tag(
      'div.btn-group > button + ul > li.dropdown-header + li + li' \
      ' > a[@href="#"][text()="Another action"]'
    )
    expect(rendered).to have_tag(
      'div.btn-group > button + ul' \
      ' > li.dropdown-header + li + li + li.divider'
    )
  end

  it 'renders pills example' do
    render inline: <<-HAML
      <%= pills do |p|
        p.link_item :active, 'Home', '#'
        p.link_item 'Profile', '#'
        p.link_item 'Messages', '#'
      end %>
    HAML
    expect(rendered).to have_tag 'ul.nav.nav-pills > li.active > a[@href="#"][text()="Home"]'
    expect(rendered).to have_tag 'ul > li + li > a[@href="#"][text()="Profile"]'
    expect(rendered).to have_tag 'ul > li + li + li > a[@href="#"][text()="Messages"]'
  end

  it 'renders breadcrumb example' do
    render inline: <<-HAML
      <%= breadcrumb do |b|
        b.link_item 'Home', '#'
        b.link_item 'Library', '#'
        b.item :active, 'Data'
      end %>
    HAML
    expect(rendered).to have_tag 'ol.breadcrumb > li > a[@href="#"][text()="Home"]'
    expect(rendered).to have_tag 'ol > li + li > a[@href="#"][text()="Library"]'
    expect(rendered).to have_tag 'ol > li + li + li.active[text()="Data"]'
  end

  it 'renders pagination example' do
    render inline: <<-HAML
      <%= pagination do |p|
        p.link_item '&laquo;', '#', :disabled
        p.link_item '1', '#', :active
        p.link_item '2', '#'
        p.link_item '3', '#'
        p.link_item '&raquo;', '#'
      end %>
    HAML
    expect(rendered).to have_tag(
      'ul.pagination > li.disabled > a[@href="#"]',
      text: '«'
    )
    expect(rendered).to have_tag(
      'ul > li.disabled + li.active > a[@href="#"]',
      text: '1'
    )
    expect(rendered).to have_tag(
      'ul > li.disabled + li.active + li > a[@href="#"]',
      text: '2'
    )
    expect(rendered).to have_tag(
      'ul > li.disabled + li.active + li + li > a[@href="#"]',
      text: '3'
    )
    expect(rendered).to have_tag(
      'ul > li.disabled + li.active + li + li + li > a[@href="#"]',
      text: '»'
    )
  end

  it 'renders pager example' do
    render inline: <<-HAML
      <%= pager do |p|
        p.previous '&larr; Older', '#', :disabled
        p.next 'Newer &rarr;', '#'
      end %>
    HAML
    expect(rendered).to have_tag(
      'ul.pager > li.previous.disabled > a[@href="#"]',
      text: '← Older'
    )
    expect(rendered).to have_tag(
      'ul.pager > li.previous.disabled + li.next > a[@href="#"]',
      text: 'Newer →'
    )
  end

  it 'renders label example' do
    render inline: <<-HAML
      <%= label :info, 'label text' %>
    HAML
    expect(rendered).to have_tag 'span.label.label-info[text()="label text"]'
  end

  it 'renders badge example' do
    render inline: <<-HAML
      <%= badge '10' %>
    HAML
    expect(rendered).to have_tag 'span.badge[text()="10"]'
  end

  it 'renders jumbotron example' do
    render inline: <<-HAML
      <%= jumbotron do %>
        <h1>Hello, world!</h1>
      <% end %>
    HAML
    expect(rendered).to have_tag 'div.jumbotron > h1'
  end

  it 'renders page-header example' do
    render inline: <<-HAML
      <%= page_header do %>
        <h1>Hello, world!</h1>
      <% end %>
    HAML
    expect(rendered).to have_tag 'div.page-header > h1'
  end

  it 'renders alert example' do
    render inline: <<-HAML
      <%= alert_box :success, :dismissable do |a| %>
        <%= a.link 'link text', 'url' %>
      <% end %>
    HAML
    expect(rendered).to have_tag 'div.alert.alert-success.alert-dismissable > button.close[@type="button"][@data-dismiss="alert"][@aria-hidden="true"] + a.alert-link[@href="url"][text()="link text"]'
  end

  it 'renders progress-bar example' do
    render inline: <<-HAML
      <%= progress_bar :striped, :success, 35, '35% total complete' do |p|
        p.bar :warning, 20, '20% files complete'
      end %>
    HAML
    expect(rendered).to have_tag 'div.progress.progress-striped > div.progress-bar.progress-bar-success[@style="width: 35%"][@role="progressbar"][@aria-valuenow="35"][@aria-valuemin="0"][@aria-valuemax="100"] > span.sr-only[text()="35% total complete"]'
    expect(rendered).to have_tag 'div.progress.progress-striped > div.progress-bar-success + div.progress-bar.progress-bar-warning[@style="width: 20%"][@role="progressbar"][@aria-valuenow="20"][@aria-valuemin="0"][@aria-valuemax="100"] > span.sr-only[text()="20% files complete"]'
  end

  it 'renders inline form example' do
    render inline: <<-HAML
      <%= form :horizontal do |f|
        f.input 'user@mail.ru', :xs_offset_2, type: 'email', id: 'exampleInputEmail2', placeholder: 'Enter email', label: ['Email address', :xs_4]
      end %>
    HAML
    #puts "*** #{rendered}"
  end
end
