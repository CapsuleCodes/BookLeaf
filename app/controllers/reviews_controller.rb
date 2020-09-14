class ReviewsController < ApplicationController  

  get '/reviews' do
      @reviews = Review.all
      erb :'reviews/index'
  end

  get "/reviews/new" do
      if logged_in?
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
          flash[:error] = "review failed #{@review.errors.full_messages.to_sentence}"
      redirect "/reviews/new"
      end
  end


  get '/reviews/:id' do
      @review = Review.find(params[:id])
      erb :"/reviews/show"
  end

  get 'reviews/:id/edit' do
      @review = Review.find(params[:id])
      if authorized_to_edit?(@review)
          erb :'/reviews/edit'
      else
          flash[:error] = "Not authorized to edit that review!"
          redirect "/reviews"
      end
  end

  patch '/reviews/:id' do 
      #@review = Review.find(params[:id])
      @review.update(title: params[:title], image_url: params[:image_url], description: params[:description])
      redirect "/reviews/#{@review.id}"
  end
  

  delete '/reviews/:id' do
     #@review = Review.find(params[:id])
      set_review
      redirect_if_not_authorized
      @review.destroy
      redirect '/reviews'
  end

private

  def set_review
    @review = Review.find_by_id(params[:id])
      if @review.nil?
       flash[:error] = "Couldn't find a Post with id: #{params[:id]}"
       redirect "/reviews"
      end
  end

end