require 'set'

class Object # http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
  def meta_def name, &blk
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
end

class Class
  
  def is_a_collection(id_method=:id, opts={})
    id_method = id_method.to_sym
    indices = [opts[:index], opts[:indices]].flatten.compact
    
    include IsACollection::InstanceMethods
    extend IsACollection::ClassMethods
    
    define_method :add_to_collection do
      primary_key = __send__(id_method)
      raise IsACollection::DuplicateKeyError if self.class.__collection[primary_key]
      self.class.__collection[primary_key] = self
      
      indices.each do |index|
        self.class.__indices[index][__send__ index].add(self)
      end
    end
    
    define_method :remove_from_collection do
      self.class.__collection.delete(__send__ id_method)
      
      indices.each do |index|
        self.class.__indices[index][__send__ index].delete(self)
      end
    end
    
    indices.each do |index|
      meta_def :"find_by_#{index}" do |genre|
        __indices[index][genre]
      end
    end
    
  end
end

module IsACollection
  class DuplicateKeyError < StandardError; end
  
  module InstanceMethods
    def initialize(*args, &block)
      super
      add_to_collection
    end
    def destroy(*args, &block)
      remove_from_collection
      super if self.class.superclass.instance_methods.include?(:destroy)
    end
  end
  
  module ClassMethods
    def __collection
      @__collection ||= {}
    end
    def all
      __collection.values
    end
    def find(identifier)
      __collection[identifier]
    end
    def clear_collection_indices
      @__collection = {}
      @__indices = Hash.new{ |hash,key| hash[key] = Hash.new{ |hash1,key1| hash1[key1] = Set.new } }
    end
    def __indices
      @__indices ||= Hash.new{ |hash,key| hash[key] = Hash.new{ |hash1,key1| hash1[key1] = Set.new } }
    end
  end
end
