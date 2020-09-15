class ReviewsController < ApplicationController  

  get '/reviews' do
      @reviews = Review.all
      erb :'reviews/index'
  end

  get "/reviews/new" do
      if logged_in?
        #@review = Review.new
          erb :"reviews/new"
      else
          flash[:error] = "User must log in"
          redirect "/"
      end
  end

  post "/reviews" do
      @review = Review.new(title: params[:title], image_url: params[:image_url], description: params[:description], user_id: current_user.id)
      if @review.save
          flash[:message] = "New review" 
          redirect "/reviews/#{@review.id}"
      else
          flash[:error] = "review failed "
          redirect "/reviews"
      end
  end


  get '/reviews/:id' do
      @review = Review.find(params[:id])
      erb :"/reviews/show"
  end

  get '/reviews/:id/edit' do
    set_review
    redirect_if_not_authorized
    erb :"reviews/edit"
  end

  patch '/reviews/:id' do 
      #@review = Review.find(params[:id])
      set_review
      redirect_if_not_authorized
      if @review.update(title: params[:title], image_url: params[:image_url], description: params[:description], user_id: current_user.id)
       flash[:success] = "Post successfully updated"
       redirect "/reviews/#{@review.id}"
     else
       erb :"/reviews/edit"
     end
  end

  delete '/reviews/:id' do
    redirect_if_not_logged_in
      @review = Review.find(params[:id])
      @review.destroy
      redirect '/reviews'
  end

private

  def set_review
    @review = Review.find_by_id(params[:id])
      if @review.nil?
       flash[:error] = "Couldn't find Review"
       redirect "/reviews"
      end
  end

 def authorized_to_edit?(review)
    @review.user == current_user
  end


  def redirect_if_not_authorized
    redirect_if_not_logged_in
    if !authorized_to_edit?(@review)
      flash[:error] = "You don't have permission to do that action"
      redirect "/reviews"
    end

  end

end