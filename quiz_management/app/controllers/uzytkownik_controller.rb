class UzytkownikController < ApplicationController
  def new
    @user = Uzytkownik.new
  end

  def create
    @user = Uzytkownik.new params[:uzytkownik]

    if @user.save
      #rendirect_to root_url, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
      render :text => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
    else
      render "new"
    end
  end
end
