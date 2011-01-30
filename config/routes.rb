MeetInTheMiddle::Application.routes.draw do
  resources :trips

#  match ':middle/:new/:id(.:format)' => 'middle#new' 
  match "middle" => "middle#new"
  
#  match ':middle/:new/:id(.:format)' => ':middle#:new'

    
  
  end
