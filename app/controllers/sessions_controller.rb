class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      logged_in!(user)
    else
    flash[:danger] = "There is something wrong with your email or password"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You logged out!"
    redirect_to root_path
  end
  
  private

  def logged_in!(user)
    session[:user_id] = user.id
    current_user
    flash[:success] = "You are logged in!"
    redirect_to home_path
  end
end