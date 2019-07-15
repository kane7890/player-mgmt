class PlayersController < ApplicationController

  get '/players/new' do
    erb :'players/new'
  end

  delete '/players/:id' do

    player=Player.find(params[:id])
    if Helpers.is_logged_in?(session)
      if Helpers.current_user(session).id != player.user_id
        redirect '/players'
      end

      player.delete
        redirect '/players'
      else
        redirect '/login'
      end
  end

  patch "/players/:id" do
    playernew= Player.find(params[:id])

    @firstname=params[:firstname]
    @lastname=params[:lastname]
    @position=params[:position]
    @user_id = params[:user_id]
    binding.pry

    if @firstname.empty? || @lastname.empty? || @position.empty?
      redirect "/players/#{playernew.id}/edit"
    end
    playernew.update({:firstname => @firstname, :lastname=> @lastname, :position=> @position, :user_id=>@user_id})

    redirect to "/players/#{playernew.id}"
  end

  get '/players/:id/edit' do
  #  binding.pry
    if Helpers.is_logged_in?(session)
      @player=Player.find(params[:id])
      curruser=Helpers.current_user(session)

      if Helpers.current_user(session).id != @player.user_id
      #     binding.pry
          redirect '/players'
      end
      # binding.pry
      erb :'players/edit'
    else
      redirect '/login'
    end
  end

  get '/players/:id' do
  #  binding.pry
    if Helpers.is_logged_in?(session)
      @player=Player.find(params[:id])
  #    binding.pry
      erb :'players/show'
    else
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

  get '/users/:id' do
    @id=params[:id]
    @players=Player.where("user_id=#{@id}")
    erb :'players/index'

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
