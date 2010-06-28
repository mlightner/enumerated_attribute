require 'enumerated_attribute/integrations/active_record'
require 'enumerated_attribute/integrations/object'
require 'enumerated_attribute/integrations/datamapper'
require 'enumerated_attribute/integrations/sequel'
require 'enumerated_attribute/integrations/default'

module EnumeratedAttribute
	module Integrations

		@@integration_map = {}
		
		def self.add_integration_map(base_klass_name, module_object, aliasing_array=[])
			@@integration_map[base_klass_name] = {:module=>module_object, :aliasing=>aliasing_array}
		end
		class << self
			alias_method(:add, :add_integration_map)
		end
		
		#included mappings
		add('Object',               Object)
		add('ActiveRecord::Base',   ActiveRecord)
        add('Sequel::Model',        Sequel)
		add('DataMapper::Resource', DataMapper)
		def self.find_integration_map(klass)
			path = "#{klass}"
			begin
				if @@integration_map.keys.each do |k|
                  if k == klass.to_s || klass.included_modules.map {|m| m.to_s }.include?(k)
                    return @@integration_map[k]
                  end                  
                end
				klass = klass.superclass
				path << " < #{klass}"
			end while klass
			raise EnumeratedAttribute::IntegrationError, "Unable to find integration for class hierarchy '#{path}'", caller
		end
	  end
	end
end