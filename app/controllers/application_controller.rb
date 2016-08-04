class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :current_user, :owns_cat?, :requester

  def login!(user)
    @current_user = user
    session[:session_token] = @current_user.reset_session_token!
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logout!
    @current_user.reset_session_token! if @current_user
    session[:session_token] = nil
  end

  def already_logged_in
    redirect_to cats_url if current_user
  end


  def owns_cat
    unless current_user.cats.any? { |cat| cat.user_id == current_user.id }
      redirect_to cats_url
    end
  end

  def owns_cat?
    return false unless current_user.cats.any? { |cat| cat.user_id == current_user.id }
    true
  end

  def requester(req)
    @requesters ||= CatRentalRequest.all.includes(:user)
    @requesters.find_by(id: req.id).user.user_name
  end
end
