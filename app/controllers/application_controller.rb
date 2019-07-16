require './config/environment'

# This is the code for the main application controller ApplicationController
class ApplicationController < Sinatra::Base

 # configuration:  tells which files the server can read, which folder to look for views
 # and enables sessions, including allowing a :session_secret
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  # root/top level controller

  get "/" do
    # checks if user is logged in.
    if Helpers.is_logged_in?(session)
      @user= Helpers.current_user(session)
      # if logged in, redirect to a list of players that belong to the user
      redirect "/users/#{@user.id}"
    else
      # if not logged in, redirect to an account page (where user can log in and sign in)
      redirect "/account"
    end
  end

end
