class Location < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :name
  acts_as_gmappable :latitude => 'latitude', :longitude => 'longitude', :process_geocoding => :geocode?,

	:address => "address", :normalized_address => "address",

	:msg => "Sorry, not even Google could figure out where that is"

	def geocode?
		(!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
	end

	def gmaps4rails_address
		address
	end

	def self.to_csv
	  CSV.generate do |csv|
	    csv << column_names
	    all.each do |location|
	      csv << location.attributes.values_at(*column_names)
	    end
	  end
	end

	def gmaps4rails_infowindow

		"<h4>#{name}</h4>" << "#{address} <br />" << "<i>Made by Zach Whitehead</i>"
	end

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			Location.create! row.to_hash
	    end
	end
end
