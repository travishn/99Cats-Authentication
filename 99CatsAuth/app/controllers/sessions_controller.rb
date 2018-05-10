class SessionsController < ApplicationController

  before_action :already_logged_in, only: [:new, :create]
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    
    if @user
      login(@user)
      redirect_to cats_url
    else
      flash[:errors] = "Incorrect username and/or password"
      redirect_to new_session_url
    end
  end
  
  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      redirect_to cats_url
    end
    
  end
end
