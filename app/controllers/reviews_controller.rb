class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find_by(id: params[:video_id])
    review = @video.reviews.build(params.require(:review).permit(:body, :rating).merge!(user: current_user))
    
    if review.save
      flash[:info] = "Your review as been added"
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end
  
  def destroy
    video = Video.find_by(params[:id])
    review = Review.find_by(params[:id])
    if @current_user.id == review.user_id
      review.destroy
      redirect_to video_path(video) 
    else
      flash[:danger] = "You do not have permission to delete this review"
      render 'videos/show'
    end
  end

end