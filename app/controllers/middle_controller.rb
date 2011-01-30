class MiddleController < ApplicationController
require 'rubygems'
require 'geokit' 
require 'net/http' 
require 'uri'
  
 def new
  # @address = Participant.new(params)
  @point_a=Geokit::Geocoders::GoogleGeocoder.geocode params[:data][:location_1]
  @point_b=Geokit::Geocoders::GoogleGeocoder.geocode params[:data][:location_2]
  result = JSON.parse(get_list_of_locations({:location_1=>@point_a,:location_2=>@point_b,:category=>params[:data][:category]}))
   logger.debug { "\n\n" }
   
   logger.debug result['response']['data']
   logger.debug { "\n\n" }       
      respond_to do |format|
        format.json {render :json=> result['response']['data'] }  #get_list_of_locations({:location_1=>@point_a,:location_2=>@point_b})}
      end
 end
 private
 
 def get_mid_point(point_a,point_b)
   point_a.midpoint_to(point_b)
 end
 
 def get_list_of_locations(opt={}) 
   uri = URI.parse("http://api.factual.com/v2/tables/bi0eJZ/read?filters=%7B%22$search%22:%22#{opt[:category]}%22,%22$loc%22:%7B%22$within%22:%7B%22$center%22:%5B%5B#{get_mid_point(opt[:location_1],opt[:location_2])}%5D,1600%5D%7D%7D%7D&api_key=S8bAIJhnEnVp05BmMBNeI17Kz3waDgRYU4ykpKU2MVZAMydjiuy88yi1vhBxGsZC")
   logger.debug { "#{uri}" }
 #  {"$search":["sushi","sashimi"],
   http = Net::HTTP.new(uri.host, uri.port)
   request = Net::HTTP::Get.new(uri.request_uri)
   response = http.request(request)
   response.body
 end
 

end