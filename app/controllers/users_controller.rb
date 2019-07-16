# UsersController for handling requests related to users/owners

class UsersController < ApplicationController

  # GET route for account matters (login, signup, logout)
  get '/account' do
    erb :'account'
  end

  # GET route for /users/:id which will list players belonging to user
  get '/users/:id' do
    # get the user object for the current sessions user
    @user=User.find(params[:id])
    # binding.pry
  #  @username = @user.Username
    curruser=Helpers.current_user(session)
    # check if the current logged-in user is the correct user that is being "queried" in '/users/id'
    if Helpers.current_user(session).id != @user.id
  #     binding.pry
      redirect '/players'
    end
    # if the current logged-in user matches the user being queried, then go to 'users/home' erb page
      erb :'users/home'
    end

  # GET route for logging in
  get '/login' do
    # if the user is already logged in, the user is sent back to the /players route
    if Helpers.is_logged_in?(session)
      puts "You are already logged in"
      redirect "/players"
    end
    # if the user is not logged in, the user is presented to the login form
    erb :'users/login'
  end

  # GET route for signing up a user
  get '/signup' do
    # if the user is already logged in, the user is sent back to the /players route
    if Helpers.is_logged_in?(session)
      puts "You are already logged in"
      redirect "/players"
    end
    # if the user is not logged in, the user is sent to the signup form
  erb :'users/signup'
  end

  # get "/failure" do
  #   erb :failure
  # end

  # POST route for signing up
  post '/signup' do
    # get the username from params hash
    @username = params[:username]
    # look for username in User class
    if User.find_by(username: @username)
      # if usernamn is already in User class/users table, the user redirected to signup form
      redirect "/signup"
    end
    # check for empty username, email or password
    if params[:email].empty? || params[:username].empty? || params[:password].empty?
      redirect "/signup"
    else
      # if username, email, and passowrd are not empty, instantiate a new user and save that new user, then set the user_id
      # of the session to the new user
      user = User.new(:email => params[:email],:username => params[:username], :password => params[:password])
      user.save
      session[:user_id] = user.id
    # binding.pry

    # go back to the players list page
    redirect "/players"
  end
end

# POST route for logging in the user
  post "/login" do

    # find the user based on username
    user = User.find_by(:username => params[:user][:username])
    # if the user exists and the password matches, then set user_id of session to that user's id
    if user && user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        # binding.pry
        redirect "/players"
      else
        # if the user either doesn't exist in User class/table or password doesn't match, the user is returned to user login
        redirect "/login"
      end
  end

  # GET route for logging out
  get "/logout" do
    if Helpers.is_logged_in?(session)
      # if someone is legged in, clear the session hash (which tracks who is logged in)
        session.clear
        redirect "/login"
    else
        redirect "/"
    end
  end


end
