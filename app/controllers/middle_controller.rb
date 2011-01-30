class MiddleController < ApplicationController
require 'rubygems'
require 'hashie'

require 'geokit' 
require 'net/http' 
require 'uri'
require 'gdirections'

 def new
   location_1=Geokit::Geocoders::GoogleGeocoder.geocode params[:data][:location_1]
   location_2=Geokit::Geocoders::GoogleGeocoder.geocode params[:data][:location_2]
   
   @middle_point_cordinates = location_1.midpoint_to(location_2)     

      result = JSON.parse(get_list_of_locations({
                              :middle_point_cordinates=>@middle_point_cordinates,
                              :category=>params[:data][:category]
                            }))
                            logger.debug { "\n\n #{result.class}" }

     final_result = result['response'].merge({
                :location_1=>location_1,
                :location_2=>location_2,
                :mp_address=>get_address_from_cordinates,
                :meeting_point=>@middle_point_cordinates.to_s,
                :original_eta=>get_eta({:origin=>location_1.full_address,:destination=>get_address_from_cordinates})
              })

      respond_to do |format|
        format.json {render :json=> final_result }
      end

      get_eta({:origin=>location_1.full_address,:destination=>get_address_from_cordinates})
 end

 private
  
 def get_address_from_cordinates
    res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode @middle_point_cordinates
    res.full_address
 end
 
 def get_mid_point(point_a,point_b)
   point_a.midpoint_to(point_b)
 end

 def get_list_of_locations(opt={}) 
   uri = URI.parse("http://api.factual.com/v2/tables/bi0eJZ/read?filters=%7B%22$search%22:%22#{opt[:category]}%22,%22$loc%22:%7B%22$within%22:%7B%22$center%22:%5B%5B#{opt[:middle_point_cordinates]}%5D,3200%5D%7D%7D%7D&api_key=S8bAIJhnEnVp05BmMBNeI17Kz3waDgRYU4ykpKU2MVZAMydjiuy88yi1vhBxGsZC")
   http = Net::HTTP.new(uri.host, uri.port)
   request = Net::HTTP::Get.new(uri.request_uri)
   response = http.request(request)
   response.body
 end

 def get_eta(opt={}) 
   directions = GoogleDirections.new(opt[:origin],opt[:destination])
   directions.drive_time_in_minutes
 end

end