class UsersController < ApplicationController


  get '/account' do
    erb :'account'
  end

  get '/users/:id' do
    @user=User.find(params[:id])
    @username = @user.Username
    erb :'users/home'
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      puts "You are already logged in"
      redirect "/players"
    end
    erb :'users/login'
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      puts "You are already logged in"
      redirect "/players"
    end
  erb :'users/signup'
  end

  get "/failure" do
    erb :failure
  end

  post '/signup' do

    @username = params[:username]
    if User.find_by(username: @username)
      redirect "/signup"
    end
    if params[:email].empty? || params[:username].empty? || params[:password].empty?
      redirect "/signup"
    else
      user = User.new(:email => params[:email],:username => params[:username], :password => params[:password])
      user.save
      session[:user_id] = user.id
    # binding.pry
    redirect "/players"
  end
end

post "/login" do
#your code here!

  user = User.find_by(:username => params[:user][:username])
  if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect "/players"
    else
      redirect "/login"
    end
end


get "/logout" do
  if Helpers.is_logged_in?(session)

      session.clear
      redirect "/login"
  else
      redirect "/"
  end
end


  #
  # # GET: /users
  # get "/users" do
  #   erb :"/users/index.html"
  # end
  #
  # # GET: /users/new
  # get "/users/new" do
  #   erb :"/users/new.html"
  # end
  #
  # # POST: /users
  # post "/users" do
  #   redirect "/users"
  # end
  #
  # # GET: /users/5
  # get "/users/:id" do
  #   erb :"/users/show.html"
  # end
  #
  # # GET: /users/5/edit
  # get "/users/:id/edit" do
  #   erb :"/users/edit.html"
  # end
  #
  # # PATCH: /users/5
  # patch "/users/:id" do
  #   redirect "/users/:id"
  # end
  #
  # # DELETE: /users/5/delete
  # delete "/users/:id/delete" do
  #   redirect "/users"
  # end
end
