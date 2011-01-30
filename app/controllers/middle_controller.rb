class MiddleController < ApplicationController
require 'rubygems'
require 'geokit' 
require 'net/http' 
require 'uri'
  
 def new
  # @address = Participant.new(params)
  @point_a=Geokit::Geocoders::GoogleGeocoder.geocode params[:data][:location_1]
  @point_b=Geokit::Geocoders::GoogleGeocoder.geocode params[:data][:location_2]
  result = JSON.parse(get_list_of_locations({:location_1=>@point_a,:location_2=>@point_b}))
   logger.debug { "\n\n" }
   
   logger.debug result['response']['data']
   logger.debug { "\n\n" }       
      respond_to do |format|
        format.json {render :json=> result['response']['data'] }  #get_list_of_locations({:location_1=>@point_a,:location_2=>@point_b})}
      end
 end
 private
 
 def get_list_of_locations(opt={})
   uri = URI.parse("http://api.factual.com/v2/tables/bi0eJZ/read?filters=%7B%22$loc%22:%7B%22$within%22:%7B%22$center%22:%5B%5B34.06948,-118.40751%5D,5000%5D%7D%7D%7D&api_key=S8bAIJhnEnVp05BmMBNeI17Kz3waDgRYU4ykpKU2MVZAMydjiuy88yi1vhBxGsZC")
   http = Net::HTTP.new(uri.host, uri.port)
   request = Net::HTTP::Get.new(uri.request_uri)
   response = http.request(request)
   response.body
 end
 
 def get_mid_point(point_a,point_b)
   point_a.midpoint_to(point_b)
 end
end