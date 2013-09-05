class SessionsController < ApplicationController
  before_filter :logged?, :only => [:create, :new]
  layout 'notlogged_application'

  def new
  end

  def create
    user = Uzytkownik.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      #redirect_to root_url, :notice => "Uzytkownik #{user.nazwa_uz} zalogowany!"
      redirect_to root_url, :notice => "Uzytkownik #{user.nazwa_uz} zalogowany"
    else
      redirect_to root_url, :alert => "Niepoprawny login lub haslo."
    end
  end

  def destroy
    #session[:user_id] = nil
    reset_session
    #redirect_to root_url, :notice => "Uzytkownik wylogowany!"
    redirect_to root_url, :notice => "Uzytkownik wylogowany"
  end

  private
  def logged?
    if current_user
      flash.now.alert = "Uzytkownik juz zalogowany!"
    end
  end

end
