class VideosController < ApplicationController
  before_action :set_videos, only:[:show]
  before_action :require_user
  
  def home
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @review = Review.new
    @reviews = @video.reviews
  end

  def search
    @search = Video.search_by_title(params[:search_term])
  end

  private

  def set_videos
    @video = Video.find(params[:id])
  end

end