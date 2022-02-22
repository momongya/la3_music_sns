require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'

enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

before '/text' do
    if current_user.nil?
        redirect '/'
    end
end

get '/' do
    erb :index
end
