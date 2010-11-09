class Class
  
  def is_a_collection(id_method=:id)
    include InstanceMethods
    extend ClassMethods
    
    define_method :add_to_collection do
      self.class.__collection[send id_method] = self
    end
    define_method :remove_from_collection do
      self.class.__collection.delete(send id_method)
    end
  end
  
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
      @__collection[identifier]
    end
  end
  
end
