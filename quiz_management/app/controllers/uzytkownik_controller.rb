class UzytkownikController < ApplicationController
  def new
  end

  def create
    uz = Uzytkownik.new params[:uzytkownik]

    if uz.save
      render :text => "Uzytkownik #{uz.nazwa_uz} zostal zarejestrowany."
    else
      render :text => "#{uz.errors.first[1]}"
    end
  end
end
