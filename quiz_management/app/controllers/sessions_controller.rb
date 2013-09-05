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
      render :notice => "Uzytkownik #{user.nazwa_uz} zalogowany"
    else
      #flash.now.alert = "Niepoprawny login lub haslo."
      render "new", :alert => "Niepoprawny login lub hasło."
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    #redirect_to root_url, :notice => "Uzytkownik wylogowany!"
    render :notice => "Uzytkownik wylogowany"
  end

  private
  def logged?
    if current_user
      render :alert => "Uzytkownik juz zalogowany!"
    end
  end

end
