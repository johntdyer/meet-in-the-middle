class CallController < ApplicationController
  require 'rubygems'
  require 'sinatra'
  require 'tropo-webapi-ruby'
  require 'net/http'
  require 'uri'
  require 'json'

  module OperatorModule

    OPERATOR_NUMBER='14074740214'
    TOKEN_ID='2c65b9f152a7014a9eaeaecd332970dc1022f7a26981b1fc4495c4df49138a41ae9beffd3647cf6a6f22c9e1'

      def call_operator(id)
        puts "call_operator(#{id})"
        uri = URI.parse("http://api.tropo.com/1.0/sessions?action=create&operator_number=#{OPERATOR_NUMBER}&token=#{TOKEN_ID}&conf_id=#{id}")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        puts "Token sent to operator HTTP/#{response.code}"
      end
  end

  include OperatorModule


   enable :sessions

  post '/' do
#       tropo_session = Tropo::Generator.parse(request.env["rack.input"].read)
#       puts tropo_session
# 
#       if tropo_session['session'].has_key?("parameters")
#         if tropo_session['session']['parameters'].has_key?("conf_id") 
# 
#           session["conf_id"] = tropo_session['session']['parameters']['conf_id']
#           puts "confid ==> #{session['confid']}"
#           session['operator_number']=tropo_session['session']['parameters']['operator_number'] 
#           puts "operator_number ==> #{session['operator_number']}"
#          
#          tropo = Tropo::Generator.new do
#            on :event => 'continue', :next => '/call_operator.json'
#          end
#        else
# #         conf_id=rand(1000000).to_s
#          session["conf_id"] = rand(1000000).to_s
#          puts "confid ==> #{session['confid']}"
#          call_operator(conf_id)  # call call_operator method which starts second session to get our 'operator' on the confernece
#          tropo = Tropo::Generator.new do
#            on :event => 'continue', :next => '/conference.json?conf_id='+conf_id
#            call(:to=>tropo_session['session']['parameters']['participant_number'],:from => '4078350065')
#          end
#       end
#      end
#      tropo.response  
  end

  post '/call_operator.json' do
    tropo_session = Tropo::Generator.parse(request.env["rack.input"].read)
     puts tropo_session

    puts "/call_operator.jsonconf_id=>#{params[:conf_id]},operator_number=>#{params[:operator_number]}"
    operator_number=params[:operator_number]
    conf_id=params[:conf_id]

    tropo = Tropo::Generator.new do
      on :event => 'continue', :next => '/events_conference.json?conf_id='+conf_id    
        call(:to=>operator_number,:from => '4078350065')
    end
    tropo.response
  end

  post '/conference.json' do 
    tropo_session = Tropo::Generator.parse(request.env["rack.input"].read)
     puts tropo_session

    puts "@/conference.json (conf_id=>#{params[:conf_id]}"

    tropo = Tropo::Generator.conference(
                    { 
                    :name       => 'foo', 
                    :id         => params[:conf_id], 
                    :mute       => false,
                    :send_tones => false,
                    :exit_tone  => '#' 
                    }) do
                      on(:event => 'join') { say :value => 'Welcome to the conference' }
                      on(:event => 'leave') { say :value => 'Someone has left the conference' }
                    end
    tropo
  end


  post '/events_conference.json' do
    tropo_session = Tropo::Generator.parse(request.env["rack.input"].read)
     puts tropo_session
    content_type :json

    conf_id=params[:conf_id]

    {
        :tropo=> [
        {
            :on=>{
                :event=> "end_confernece",
                :next=>"/end_confernece.json"
            }
        },
        {
            :conference=> {
                :playTones=>true,
                :name=>"foo",
                :terminator=>"#",
                :id=>conf_id,
                :mute=>false
            }
        }
        ]
    }.to_json
  end




  post '/hangup.json' do
    p 'Received a hangup response!'
    json_string = request.env["rack.input"].read
    tropo_session = Tropo::Generator.parse json_string
    p tropo_session
  end
  
end
