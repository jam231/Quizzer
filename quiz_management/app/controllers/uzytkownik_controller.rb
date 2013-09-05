class UzytkownikController < ApplicationController
  layout 'notlogged_application', :only => [:new]

  def new
    @user = Uzytkownik.new

  end

  def create
    @user = Uzytkownik.new params[:uzytkownik]

    if @user.save
      #rendirect_to root_url, :notice => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
      render :text => "Uzytkownik #{@user.nazwa_uz} zostal zarejestrowany."
    else
      if @user.errors.any?
        @user.errors.full_messages.each_with_index do |message, index|
          flash['user_new_error' + index.to_s] = :alert, message
        end
      end
      render "new"
    end
  end
end
