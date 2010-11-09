require File.join( File.expand_path(File.dirname(__FILE__)), '../lib/is_a_collection' )

class A
  is_a_collection
  
  def initialize(*args)
    super
  end
  
  def id
    object_id
  end
  
end

class B
  attr_reader :name
  is_a_collection :name
  
  def initialize(name)
    @name = name
    add_to_collection
  end
  
end

describe "is_a_collection" do
  describe "#all" do
    describe "without any instances" do
      it "should be empty" do
        A.all.should be_empty
      end
    end
    describe "with some instances" do
      it "should return these instances" do
        a1 = A.new
        a2 = A.new
        A.all.should == [a1,a2]
      end
    end
  end
  describe "#find" do
    it "should return the instance by default identifier (#object_id)" do
      a = A.new
      A.find(a.object_id).should == a
    end
    it "should return the instance by custom identifier" do
      b = B.new('foobar')
      B.find('foobar').should == b
    end
  end
  describe "#destroy" do
    before(:each) do
      @b = B.new('doomed')
    end
    it "should remove the instances" do
      @b.destroy
      B.find('doomed').should be_nil
    end
  end
end