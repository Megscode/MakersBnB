require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models/booking.rb'
require './models/space.rb'
require './models/user.rb'

class MakersBnB < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/landing_page' do
    erb :"landing_page/landing_page"
  end

  get '/' do
    erb :index
  end

  get '/spaces' do
    erb :"/spaces/index"
    # @get_spaces = {}
    # @spaces.each { |space| @get_spaces[space.name] = space.description }
    # @get_spaces.to_json
    # "space_1 Space Mansion £50 Lovely space!"
  end

  get '/spaces/new' do
    erb :spaces_new
  end

  post '/spaces' do
    Space.create(name: params['name'], description: params['description'], price: params['price'], photo_url: params['photo_url'], user: User.find_by(id: session[:user_id]))
    redirect '/spaces'
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/users' do
    User.create(name: params['name'], email: params['email'], password: params['password'])
    session[:user_id] = User.find_by(email: params['email']).id
    redirect '/spaces'
  end

  get '/sessions/new' do 
    erb :"sessions/new"
  end

  post '/sessions' do 
    if User.where(email: params['email'], password: params['password']).exists?
      session[:user_id] = User.find_by(email: params['email']).id
      redirect '/spaces'
    else
      flash[:notice1] = 'Wrong credentials, dummy! :( '
      redirect '/sessions/new'
    end
  end
  
  post '/requests' do
    Booking.create(booking_date: params[:booking_date], user: User.find_by(id: session[:user_id]), space: Space.find_by(id: session[:space_id]), confirmed: 'false')
    erb :requests
  end

  get '/bookings' do
    erb :bookings
  end

  post '/bookings' do 
    session[:space_id] = Space.find_by(name: params[:choice]).id
    redirect '/bookings'
  end

  get "/requests" do
     erb :requests
  end

  post '/sessions/destroy' do
    session.clear
    flash[:notice2] = "You have successfully signed out"
    redirect '/sessions/new'
  end
end
