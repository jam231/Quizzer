class UzytkownikController < ApplicationController
  layout 'notlogged_application', :only => [:new, :create]

  def new
    @user = Uzytkownik.new

  end

  def create
    @user = Uzytkownik.new params[:uzytkownik]

    if @user.save
      #rendirect_to root_url, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
      redirect_to new_sessions_path, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
    else
      alert_msg = ''
      if @user.errors.any?
        # jeszcze nie wiem co z tym zrobić.
        alert_msg = @user.errors.full_messages.first().to_s
      end
      redirect_to new_uzytkownik_path, :alert => alert_msg
    end
  end
end
