require 'spec_helper'

describe Bootstrap::ViewHelpers::Base do
  # TODO: add specs for initialization and other new stuff

  it 'sets tag to "div" by default' do
    expect(successor.tag).to eq 'div'
  end

  it {expect(successor.render).to have_selector 'div'}

  # TAG
  it 'sets default tag from TAG constant' do
    successor_class.class_eval do
      const_set :TAG, 'input'
    end
    expect(successor.tag).to eq 'input'
  end

  it 'sets tag from options' do
    expect(successor(tag: :p).tag).to eq 'p'
  end

  # helper_name
  it 'sets @helper_name variable from arguments' do
    expect(successor(helper_name: 'test').instance_variable_get :@helper_name).to eq 'test'
  end

  it 'gets helper name from class variable helper_name' do
    successor_class.class_eval {self.helper_names = 'test'}
    expect(successor.instance_variable_get :@helper_name).to eq 'test'
  end

  it 'gets helper name from class array variable helper_name' do
    successor_class.class_eval {self.helper_names = ['test1', 'test2']}
    expect(successor.instance_variable_get :@helper_name).to eq 'test1'
  end

  it {expect(successor_class.helper_names).to be_nil}

  # options cleaning
  it {expect(successor(tag: :p)).to_not have_option :tag}

  # rendering
  it 'includes render arguments to html' do
    expect(successor.render '<p></p>'.html_safe).to have_selector 'div > p'
  end

  it 'includes render block result to html' do
    expect(successor.render('<p></p>'.html_safe) {'<i></i>'.html_safe}).to have_selector 'div > p + i'
  end

  # flags
  context 'have flag "active"' do
    before {successor_class.class_eval {self.flag :active, aliases: [:test, :alias]}}

    it 'creates flag getter and setter' do
      expect(successor.active?).to be_false
      successor.active = true
      expect(successor.active?).to be_true
    end

    it 'sets flag from symbol arguments and remove it from arg list' do
      expect(successor(:active).active?).to be_true
      expect(successor.instance_variable_get :@args).to_not include :active
    end

    it 'sets flag from options and cleanup options' do
      expect(successor(active: true).active?).to be_true
      @successor = nil; expect(successor(active: false).active?).to be_false
      @successor = nil; expect(successor active: true).to_not have_option :active
      @successor = nil; expect(successor active: false).to_not have_option :active
    end

    it 'supports aliases in arguments' do
      expect(successor(:alias).active?).to be_true
      expect(successor.instance_variable_get :@args).to_not include :alias
    end

    it 'supports aliases in options' do
      expect(successor(test: true).active?).to be_true
      expect(successor test: true, alias: true, active: true).to_not have_option :active, :alias, :test
    end
  end

  # enums
  context 'have enum "state"' do
    before {successor_class.class_eval {self.enum :state, [:info, :danger]}}

    it 'creates enum getter and setter' do
      expect(successor.state).to be_nil
      successor.state = :info
      expect(successor.state).to eq :info
      successor.state = :test
      expect(successor.state).to eq :info
    end

    it 'sets enum from symbol arguments and remove it from arg list' do
      expect(successor(:info).state).to eq :info
      expect(successor.instance_variable_get :@args).to_not include :info
    end

    it 'sets flag from options and cleanup options' do
      expect(successor(state: :info).state).to eq :info
      @successor = nil; expect(successor(state: :test).state).to be_nil
      @successor = nil; expect(successor state: :info).to_not have_option :state
      @successor = nil; expect(successor state: :test).to_not have_option :state
    end
  end
end