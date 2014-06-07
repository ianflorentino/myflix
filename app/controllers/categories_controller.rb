class CategoriesController < ApplicationController
  before_action :set_categories, only: [:show]
  
  def show
    @video = Video.find(params[:id])
  end

  private

  def set_categories
    @category = Category.find(params[:id])
  end
end