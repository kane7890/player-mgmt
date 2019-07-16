
# Players Controller -- controller for handling transactions involving Player model
# and thus the players table through ActiveRecord

class PlayersController < ApplicationController

  # get request for (adding) a new player
  get '/players/new' do
    # call erb file 'players/new', which displays a form for adding a new player
    erb :'players/new'
  end

  # delete request (which is handled via /post and middleware)
  delete '/players/:id' do
    # find the player based on :id, which gets passed to params[:id] hash
    player=Player.find(params[:id])
    # check that the user is logged in -- and is the user_id (owner) for the player being deleted
    if Helpers.is_logged_in?(session)
      # if the logged-in user does not match the user_id of the player being deleted, the player doesn't gets
      # deleted and the user is redirected to his player list
      if Helpers.current_user(session).id != player.user_id
        redirect '/players'
      end
      # if the user_id of the player does match the id of the logged-in user, delete the player object
      player.delete
        redirect '/players'
      else
      # if NO user is logged in, go back to the login page
        redirect '/login'
      end
  end

  # /patch route for editing information for a given player
  patch "/players/:id" do
    playernew= Player.find(params[:id])

    # get firstname, lastname, and positionm from params (from players/edit.erb form)
    @firstname=params[:firstname]
    @lastname=params[:lastname]
    @position=params[:position]
    # in case we want to change the user_id (future)
    @user_id = params[:user_id]
    # binding.pry

    # check to see if any entered fields are empty, and if so then redirect to edit route (back to edit form)
    if @firstname.empty? || @lastname.empty? || @position.empty? || @user_id.empty?
      redirect "/players/#{playernew.id}/edit"
    end
    # if firstname, lastname, position are not empty, then update the fields
    playernew.update({:firstname => @firstname, :lastname=> @lastname, :position=> @position, :user_id=>@user_id})
    # redirect the user to the player's show page
    redirect to "/players/#{playernew.id}"
  end

  # GET route for editing player information
  get '/players/:id/edit' do
  #  binding.pry
    # check to see if user is logged in, and if the user_id of the player-to-be-modified matches the logged-in user
    if Helpers.is_logged_in?(session)
      @player=Player.find(params[:id])
      curruser=Helpers.current_user(session)
      # if the logged-in user (in the session) doesn't match the user_id of player-to-be-modified, redirect to players
      if Helpers.current_user(session).id != @player.user_id
        redirect '/players'
      end
      # binding.pry
      # if player's user_id matched logged-in user, then send user to an edit form
      erb :'players/edit'
    else
      # if user isn't even logged in, redirect to a login page
      redirect '/login'
    end
  end

  # GET route for showing player information
  get '/players/:id' do
  #  binding.pry
    # check that the user is logged in
    if Helpers.is_logged_in?(session)
      @player=Player.find(params[:id])
  #    binding.pry
      erb :'players/show'
    else
      # if user is not logged in, redirect to login page for login
      redirect '/login'
    end
  end

  
  get '/players' do
    # binding.pry
      if Helpers.is_logged_in? (session)
        curr_user = Helpers.current_user(session)
        @players = Player.where(user: curr_user)
        erb :'players/index'
      else
        redirect '/login'
      end
  end

  post '/players' do

    if  !(params[:firstname].empty?) && !(params[:lastname].empty?) && !(params[:position].empty?)
      playernew=Player.create(firstname: params[:firstname], lastname: params[:lastname], position: params[:position], user_id: session[:user_id])
      redirect "/players/#{playernew.id}"
    else
      redirect '/players/new'
    end


  end


end
