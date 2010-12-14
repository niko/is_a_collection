require "is_a_collection"

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
A.all             # => [#<A:0x00000101636170>]
b = A.new
A.all             # => [#<A:0x00000101636170>, #<A:0x00000101635c70>]
A.find(a.id)      # => #<A:0x00000101636170>

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
B.all             # => [#<B:0x000001016351f8 @name="foo">]
b = B.new('bar')
B.all             # => [#<B:0x000001016351f8 @name="foo">, #<B:0x00000101634c80 @name="bar">]
B.find('foo')     # => #<B:0x000001016351f8 @name="foo">
B.find('foo').destroy
B.all             # => [#<B:0x00000101634c80 @name="bar">]
