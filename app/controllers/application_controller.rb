require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #enables sessions from users controller
    enable :sessions
    #then set a session secret for extra layer of security
    set :session_secret, "dbz"
    register Sinatra::Flash
  end

  get "/" do
    if logged_in?
      redirect "/user/#{current_user.id}"
    else
      erb :welcome
    end
  end

  helpers do

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

    def authorized_to_edit?(review)
      @review.user == current_user
    end

  end

  private
 
  def redirect_if_not_logged_in
    if !logged_in?
      flash[:error] = "You must be logged in to view that page"
      redirect request.referrer || "/login"
    end
  end
end