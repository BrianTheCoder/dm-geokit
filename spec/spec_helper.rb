$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
%w(dm-geokit).each{|l| require l}

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "mysql://root@localhost/dm_geokit_test")
GeoKit::Geocoders::google = 'ABQIAAAAdh4tQvHsPhXZm0lCnIiqQxQK9-uvPXgtXTy8QpRnjVVz0_XBmRQRzegmnZqycC7ewqw26GJSVik0_w'
class Location
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
  has_geographic_location :address
  has n, :comments
end

class ValidatingLocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
  has_geographic_location :address
  validates_with_block do
    !self.address_full_address.blank?
  end
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :location_id, Integer
  belongs_to :location
end

class UninitializedLocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
end

class NoDefaultGeocodeLocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
  has_geographic_location :address, :auto_geocode => false
end

class DefaultGeocodeLocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  property :id, Serial
  has_geographic_location :address, :auto_geocode => true
end

DataMapper.auto_migrate!

