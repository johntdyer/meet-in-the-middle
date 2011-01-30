class RoutesController < ApplicationController
  def get_eta         
    
    #http://localhost:3000/eta?lat=28.51246&lng=-81.216396
    t =  Trip.find(params[:id])
        directions = GoogleDirections.new(
                                          get_address_from_cordinates(params[:lat]+","+params[:lng]),
                                          get_address_from_cordinates(t.destination)
                                          )

      render :json => {
                :lat=>params[:lat],
                :lng=>params[:lng],
                :original_eta=>t.original_eta.strftime('%H:%M:%S'),
                :travel_time=>directions.drive_time_in_minutes,
                :new_eta=>(Time.now+(directions.drive_time_in_minutes).minutes).strftime('%H:%M:%S')
              }, :layout => true
  end

  private
  
  def get_address_from_cordinates(cordinates)
     res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode cordinates
     res.full_address
  end
end
