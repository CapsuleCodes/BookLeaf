class UsersController < ApplicationController

    #Render login form
  get "/login" do                                          #when we send a get request to this route, it renders our login erb file
    erb :'/users/login'                                  #renders our login form
  end

                                  #receive data from params from the login form via POST route
                                  #received from form action in login.erb
                                  #method is post, do block
                                  #data is sent via POST or Patch route
                                   #user&&user authenticate is from has_secure_password macro
                                  #log them in
                                  #create a key value pair in the session hash using the user_id to actually log in
                                  #binding.pry, then shotgun /login then enter email in webpage then run params in terminal
                                  # params key comes from login.erb password and email name

  post "/login" do                                          #receives data from login form(params)
        @user = User.find_by(email: params[:email])           #find the user  #authenicate user then next step
     if @user && @user.authenticate(params[:password])      #authenicate our use.take password and 
        session[:user_id] = @user.id
        flash[:message] = "Welcome, #{@user.name}!"
        redirect "/users/#{@user.id}"
      else 
        flash[:error] = "Wrong username or password. Please try again!"
        redirect "/login"
      end
  end

    #users show route
  get "/users/:id" do
      @user = User.find_by(id: params[:id])
      erb :'/users/show'
  end

  get '/signup' do #get sign up route that renders signup form
    erb :'/users/signup'
  end

  post '/users' do
    @user = User.create(params)
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end