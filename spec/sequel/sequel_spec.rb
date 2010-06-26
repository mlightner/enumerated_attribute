#require 'test_in_memory'
require 'rubygems'
require 'sequel'
require 'enumerated_attribute'
require 'race_car'
describe "Sequel integration: " do
  subject { RaceCar.new }
  context "setters" do
    it "should work with plain <method=>" do
      subject.gear = :first
      subject.should be_in_first
      subject.gear = "neutral"
      subject.should be_in_neutral    
    end

    it "should work with #set(hash)" do
      subject.set :gear => "neutral"
      subject.should be_in_neutral
      subject.set :gear => :first
      subject.should be_in_first
    end

    it "should work with #new(hash)" do
      RaceCar.new(:gear => :first).should be_in_first
      RaceCar.new(:gear => 'first').should be_in_first
    end
  end

  context "getters" do
    it "should work" do
      subject.gear = :neutral
      subject.gear.should == :neutral
    end

    it "should convert strings to symbols" do
      subject.gear = "neutral"
      subject.gear.should == :neutral
    end
  end

  it "should not raise exceptions on save" do
    lambda {
      subject.save
    }.should_not raise_error
  end

  it "should store strings in database" do
    subject.gear = :neutral
    subject.save
    RaceCar[subject.id].gear.should == :neutral
  end

  it "should assign default values" do
    subject.should be_in_neutral
  end
end