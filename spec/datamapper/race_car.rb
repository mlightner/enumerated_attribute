#DB = Sequel.sqlite
#DB.create_table :race_cars do
#  primary_key :id
#  String :gear
#  String :choke
#end
DataMapper.setup(:default, 'sqlite::memory:')

class RaceCar
  include DataMapper::Resource
  property :id, Serial
  property :gear, String
  property :choke, String
  enum_attr :gear, %w( reverse ^neutral first second over_drive )
  enum_attr :choke, %w( ^none medium full )
end

DataMapper.auto_migrate!

#gear = enumerated column attribute
#choke = enumerated non-column attribute
#lights = non-enumerated column attribute

=begin
	t.string :name
	t.string :gear
	t.string :lights
=end
