class UzytkownikController < ApplicationController
  layout 'notlogged_application', :only => [:new, :create]
  before_filter :logged?, :only => [:update, :show]

  def new
    @user = Uzytkownik.new
  end

  def create
    @user = Uzytkownik.new params[:uzytkownik]

    if @user.save
      redirect_to log_in_url, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
    else
      alert_msg = ''
      alert_msg = @user.errors.full_messages.values.first.first.to_s if @user.errors.any?
      redirect_to log_in_url, :alert => alert_msg
    end
  end


  def update
	  user = Uzytkownik.find params[:id_uz]
	  if user.update_attributes(:nazwa_uz => params[:nazwa_uz], :login => params[:login], :email => params[:email])
			redirect_to user_edit_url, :notice => "Zapisano zmiany."
	  else
		  alert_msg = ''
		  alert_msg = user.errors.messages.values.first.first.to_s if user.errors.any?
		  redirect_to user_edit_url, :alert => alert_msg
	  end
  end

  def edit
		@user = current_user
  end
end
