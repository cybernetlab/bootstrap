require 'spec_helper'

describe 'assets pipeline' do
  it 'includes application.js itself' do
    expect('application.js').to compile_with 'var application_js'
  end

  it 'includes user.js' do
    expect('application.js').to compile_with 'var user_js'
  end

  it 'includes bootstrap.js' do
    expect('application.js').to compile_with 'Bootstrap'
  end

  it 'includes application.css itself' do
    expect('application.css').to compile_with '#application_css'
  end

  it 'includes user.css' do
    expect('application.css').to compile_with '#user_css'
  end

  it 'includes bootstrap.css' do
    expect('application.css').to compile_with 'Bootstrap'
    expect('application.css').to compile_with 'Font Awesome'
  end

  it 'includes fonts' do
    expect('fontawesome-webfont.eot').to be_in_precompile_list
  end

  it 'doesn\'t includes user fonts' do
    expect('userfont.eot').to be_in_precompile_list
  end

  context 'font_awesome disabled' do
    before {Bootstrap.config.font_awesome = false}
    after {Bootstrap.config.font_awesome = true}

    it 'doesn\'t include font-awesome.css' do
      expect('application.css').to compile_with 'Bootstrap'
      expect('application.css').to_not compile_with 'Font Awesome'
    end
  end
end