class SessionsController < ApplicationController
  def new
  end

  def create
    user = Uzytkownik.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      #redirect_to root_url, :notice => "Uzytkownik #{user.nazwa_uz} zalogowany!"
      render :text => "Uzytkownik #{user.nazwa_uz} zalogowany"
    else
      flash.now.alert = "Niepoprawny login lub haslo."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    #redirect_to root_url, :notice => "Uzytkownik wylogowany!"
    render :text => "Uzytkownik wylogowany"
  end
end
