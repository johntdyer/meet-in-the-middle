MeetInTheMiddle::Application.routes.draw do
#  match ':middle/:new/:id(.:format)' => 'middle#new' 
  match "middle" => "middle#new"
  
#  match ':middle/:new/:id(.:format)' => ':middle#:new'

  resources :trips

    
  
  end
