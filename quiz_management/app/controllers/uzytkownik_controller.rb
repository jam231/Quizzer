class UzytkownikController < ApplicationController
  layout 'notlogged_application', :only => [:new, :create]

  def new
    @user = Uzytkownik.new

  end

  def create
    @user = Uzytkownik.new params[:uzytkownik]

    if @user.save
      #rendirect_to root_url, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
      redirect_to log_in_url, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
    else
      alert_msg = ''
      alert_msg = @user.errors.full_messages.first().to_s if @user.errors.any?
      redirect_to log_in_url, :alert => alert_msg
    end
  end

  def my_profile
    @user = current_user
		redirect_to :back, :alert => 'Not implemented yet.'
  end
end
