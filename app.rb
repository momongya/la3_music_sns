require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'
require 'open-uri'
require 'json'
require 'net/http'
require 'sinatra/activerecord'

enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

# before '/text' do
#     if current_user.nil?
#         redirect '/'
#     end
# end

get '/' do
    erb :index
end

get '/home' do
    erb :home
end

get '/search' do
    uri = URI("https://itunes.apple.com/search")
    uri.query = URI.encode_www_form({
        term: params[:keyword],
        media: "music"
    })
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    @music = json["results"]
    erb :search
end

get '/signup' do
    erb :signup
end

post '/signin' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/'
end

post '/signup' do
    img = params[:topimg]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
    
    user = User.create(
        name: params[:name],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        image_name: img_url
    )
    
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/home'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end
