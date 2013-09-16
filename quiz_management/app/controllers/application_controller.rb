# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :not_logged?, :logged?

  def current_user
	  @current_user ||= Uzytkownik.find(session[:user_id]) if session[:user_id]
  end

  def not_logged?
	  redirect_to grupa_public_url unless current_user.nil?
  end

  def logged?
		redirect_to log_in_url, :alert => "Aby uzyskać dostęp musisz sie zalogować"  if current_user.nil?
  end
end
