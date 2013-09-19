# encoding: UTF-8
class SessionsController < ApplicationController
  before_filter :not_logged?, :only => [:create, :new]
  before_filter :logged?, :only => [:destroy]
  layout 'notlogged_application'

  def new
  end

  def create
    user = Uzytkownik.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Użytkownik #{user.nazwa_uz} zalogowany"
    else
      redirect_to log_in_url, :alert => "Niepoprawny login lub hasło."
    end
  end

  def destroy
    nazwa_uz = current_user.nazwa_uz
    reset_session
    redirect_to log_in_url, :notice => "Użytkownik został #{nazwa_uz} wylogowany"
  end
end
