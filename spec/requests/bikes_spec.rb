require 'spec_helper'

describe "Bikes" do

  subject { page }

  describe "home page" do
    before { visit '/' }
    it { should have_selector('h1', text: 'Bike#home') }
  end

  describe "About page" do
    before { visit '/about' }
    it { should have_selector('h1', text: 'Bike#about') }
  end

end