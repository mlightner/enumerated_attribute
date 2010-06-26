module EnumeratedAttribute
  module Integrations
    module Sequel
      def self.included(base)
        base.extend ClassMethods
      end
      
      def write_enumerated_attribute(name, val)
        name = name.to_s
        val = nil if val == ''
        val = val.to_sym if val
        unless self.class.enumerated_attribute_allows_value?(name, val)
          raise(InvalidEnumeration, "nil is not allowed on '#{name}' attribute, set :nil=>true option", caller) unless val
          raise(InvalidEnumeration, ":#{val} is not a defined enumeration value for the '#{name}' attribute", caller)
        end
        self[name] = val.to_s
      end

      def read_enumerated_attribute(name)
        name = name.to_s
        self[name] ? self[name].to_sym : self[name]
      end

      def initialize(*args, &block)
        super
        initialize_enumerated_attributes(true)        
      end
      module ClassMethods
        def define_enumerated_attribute_new_method; end
      end
    end
  end
end