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
      alert_msg = @user.errors.full_messages.first().to_s if @user.errors.any?
      redirect_to new_uzytkownik_path, :alert => alert_msg
    end
  end

  def my_profile
    @user = current_user
  end
end
