require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  # root/top level controller

  get "/" do
    if Helpers.is_logged_in?(session)
      @user= Helpers.current_user(session)
      redirect "/users/#{@user.id}"
    else
      redirect "/account"
    end
  end

  # get '/' do
  #
  # erb :home
  #
  # end
end
