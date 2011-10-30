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

class C
  is_a_collection
end

class Song
  attr_reader :title, :genre
  is_a_collection :title, :index => :genre
  
  def initialize(title, genre)
    @title, @genre = title, genre
    add_to_collection
  end
  def destroy
    remove_from_collection
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
  describe "on primary key collision" do
    it "raise an error" do
      b1 = B.new('a key')
      lambda{ B.new('a key') }.should raise_error(IsACollection::DuplicateKeyError)
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
    it "should work without instances" do
      C.find('bla')
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
  describe "indices" do
    after(:each) do
      Song.clear_collection_indices
    end
    describe "on instance creation" do
      it "adds instances to the index" do
        s1 = Song.new 'some title', 'Rock'
        s2 = Song.new 'some other title', 'Rock'
        Song.find_by_genre('Rock').should include(s1)
        Song.find_by_genre('Rock').should include(s2)
      end
      it "doesn't add instances to other indices" do
        s1 = Song.new 'some title', 'Rock'
        s2 = Song.new 'some other title', 'Pop'
        Song.find_by_genre('Rock').should_not include(s2)
      end
    end
    describe "on instance destruction" do
      it "removes the instance from the index" do
        s = Song.new 'some other title', 'Rock'
        Song.find_by_genre('Rock').should include(s)
        s.destroy
        Song.find_by_genre('Rock').should_not include(s)
      end
    end
  end
end