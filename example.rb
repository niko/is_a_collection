# require "is_a_collection"
require_relative "lib/is_a_collection"

class A
  is_a_collection
  
  def initialize(*args)
    super
  end
  
  def id
    object_id
  end
end

a = A.new
A.all             # => [#<A:0x00000101b9d668>]
b = A.new
A.all             # => [#<A:0x00000101b9d668>, #<A:0x00000101b9ce48>]
A.find(a.id)      # => #<A:0x00000101b9d668>
a.destroy
A.all             # => [#<A:0x00000101b9ce48>]

class B
  attr_reader :name
  is_a_collection :name
  
  def initialize(name)
    @name = name
    add_to_collection
  end
  def destroy
    remove_from_collection
  end
end

a = B.new('foo')
B.all             # => [#<B:0x00000101b9b778 @name="foo">]
b = B.new('bar')
B.all             # => [#<B:0x00000101b9b778 @name="foo">, #<B:0x00000101b9b138 @name="bar">]
B.find('foo')     # => #<B:0x00000101b9b778 @name="foo">
a.destroy
B.all             # => [#<B:0x00000101b9b138 @name="bar">]

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


s1 = Song.new 'foobar', 'Rock'
s2 = Song.new 'foobaz', 'Rock'
s3 = Song.new 'fuu', 'Pop'


p Song.find_by_genre('Rock')


