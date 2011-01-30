MeetInTheMiddle::Application.routes.draw do
  resources :trips

  match "middle" => "middle#new"

  match "eta(/:id)", :to =>  "routes#get_eta"
  
  match "/poll(/*data)", :to => proc { |env| 
    
    req=Rack::Request.new(env)
    
    [200, 
    { "Content-Type" => "application/json" },
          poll({
            :trip_id=>env["action_dispatch.request.path_parameters"],
            :lat=>req.params['lat'],
            :lng=>req.params['lng']
            })
    ] }
   
  
  
     match "/call(/*data)", :to => proc { |env| 

        req=Rack::Request.new(env)

        [200, 
        { "Content-Type" => "application/json" }, 

              call({
                :trip_id=>env["action_dispatch.request.path_parameters"],
                :phone_number=>env["QUERY_STRING"],

                })


         ] }
         
  
  
  def call(opt={}) 
    t = Trip.find(opt[:trip_id][:data])
    call_json = '{
                     "tropo": [
                         {
                             "message": {
                                 "say": {
                                     "value": "Hello, '+t.contact.first+' is running late, we are just calling you to let you know.  Thank you for using meet me in the middle"
                                 },
                                 "to": "'+t.contact.phone+'",
                                 "from": "4075551212",
                                 "voice": "dave",
                                 "timeout": 10,
                                 "answerOnMedia": false
                             }
                         }
                     ]
                 }' 
  end
  
 # LateURL ---> http://localhost:3000/poll/1?lat=28.51246&lng=-81.216396
# onTimeURL ---> http://localhost:3000/poll/1?lat=28.51246&lng=-81.216396   
  def poll(opt={})

    t = Trip.find(opt[:trip_id][:data])
    
    directions = GoogleDirections.new(
                                      get_address_from_cordinates(opt[:lat]+","+opt[:lng]),
                                      get_address_from_cordinates(t.destination)
                                      )

     
    new_eta = Time.now.utc+directions.drive_time_in_minutes.to_i.minutes
    original_eta = Time.parse(t.original_eta.to_s) 
    
    #puts "\n\tOriginal Time \t--->\t#{original_eta}" 

    #puts "\tNew Time \t--->\t#{new_eta} \n"
    
    if ((new_eta-original_eta)/60) > 5
      {
          :onTime=>false,
          :poll_result=>{
               :original_eta=>original_eta,
               :new_eta=>new_eta,
               :how_late=>"%.1f" % ((new_eta-original_eta)/60)
             }
        }.to_json
     else
       {  
         :onTime=>true,
         :poll_result=>{
              :original_eta=>original_eta,
              :new_eta=>new_eta,
              :how_late=>"%.1f" % ((new_eta-original_eta)/60)
            }
       }.to_json

    end
  end
   def get_address_from_cordinates(cordinates)
      res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode cordinates
      res.full_address
   end
   
   
  end
