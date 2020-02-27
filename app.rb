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
    p params['available_to']
    p params['available_from']
    Space.create(name: params['name'], description: params['description'], price: params['price'], photo_url: params['photo_url'], available_from: params['available_from'], available_to: params['available_to'], user: User.find_by(id: session[:user_id]))
    redirect('/')
  end

  get '/sign_up' do
    erb :sign_up
  end

  get '/login' do
    erb :login
  end

  get '/sessions/new' do 
    erb :"sessions/new"
  end

  post '/sessions' do 
    if User.where(email: params['email'], password: params['password']).exists?
      session[:user_id] = User.find_by(email: params['email']).id
      redirect('/spaces')
    else
      flash[:notice1] = 'Wrong credentials, dummy! :( '
      redirect('/sessions/new')
    end
  end
  
  post '/users' do
    User.create(name: params['name'], email: params['email'], password: params['password'])
    redirect '/welcome'
  end

  get '/welcome' do
    "Welcome, #{User.all.last.name}"
  end

  post '/sessions/destroy' do
    session.clear
    flash[:notice2] = "You have successfully signed out"
    redirect('/sessions/new')
  end
  
  run! if app_file == $0
end 



