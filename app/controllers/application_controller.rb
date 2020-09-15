require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #enables sessions from users controller
    enable :sessions
    #then set a session secret for extra layer of security
    set :session_secret, "dbz"
    set :method_override, true
    register Sinatra::Flash
  end

  get "/" do
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      redirect "/signup"
    end
  end

  not_found do
    flash[:error] = "Not found"
    if logged_in?
      redirect :'/reviews'
    else
      redirect '/'
    end
  end

  private

    def logged_in?
      !!current_user
    end
                #we want a boolean if the user is logged in or not
                #def logged_in method

                    #this keeps track of the current user,and doesnt allow user if not logged in to create a review
    def current_user
      User.find_by(id: session[:user_id])#finds user thats logged in by key value pair in users_controller 
                                         #User.find(session[user_id]) would work also but we need a truthy or a falsey value
    end

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:error] = "You must be logged in to view that page"
        redirect request.referrer || "/login"
      end
    end
    
  
 
 
end