class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  
  def current_user 
    return nil if session[:session_token].nil? #saves need for database query below
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def login(user)
    @current_user = user #saves need for database query above
    session[:session_token] = user.reset_session_token!
  end
  
  def require_login
    redirect_to new_user_url if current_user.nil? 
  end
  
  def require_login_cats
    redirect_to cats_url if current_user.nil?
  end
  
  def already_logged_in
    redirect_to cats_url if current_user
  end
  
  def require_confirm_user
    require_login_cats
    redirect_to  cats_url unless current_user.cats.where(id: params[:user_id])
  end
  
  def require_confirm_catrental
    require_login_cats
    redirect_to cats_url unless current_user.cat_rental_requests.where(id: params[:user_id])
  end
  
end
