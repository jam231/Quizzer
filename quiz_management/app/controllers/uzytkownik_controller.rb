class UzytkownikController < ApplicationController
  def new
    #Uzytkownik.create params[:uzytkownik]
  end

  def create
    uz = Uzytkownik.create params[:uzytkownik]

    if uz
      render :text => "Uzytkownik #{uz.nazwa_uz} zostal zarejestrowany."
    else
      render :text => "Z jakiegos powodu sie nie powiodlo..."
    end
  end
end
