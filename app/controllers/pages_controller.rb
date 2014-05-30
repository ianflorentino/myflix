class PagesController < ApplicationController
  def front

    if logged_in?
      @categories = Category.all
      render 'videos/home'
    else
      render :front
    end
  end
end