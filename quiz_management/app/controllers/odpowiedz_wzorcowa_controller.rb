class OdpowiedzWzorcowaController < ApplicationController

  def update
    @ow = OdpowiedzWzorcowa.where("tresc_odp = ? AND id_pyt = ?", params[:odpowiedz_wzorcowa][:tresc_odp] , params[:odpowiedz_wzorcowa][:id_pyt])[0]
    puts "--------------------------@@@@@@@@@ #{@ow[0]}"
    @ow.ost_modyfikacja = Time.now
    @ow.update_attributes(params[:odpowiedz_wzorcowa].except(:id_pyt, :tresc_odp))
    @ow.save
    redirect_to edit_pytanie_url(:id => @ow.id_pyt), notice: 'Pytanie zapisane.'
    #redirect_to pytanie_edit_path(:id_pyt => @ow.id_pyt), notice: 'Odpowiedz zmieniona.'
  end

  def create
    @ow = OdpowiedzWzorcowa.new(params[:odpowiedz_wzorcowa])
    @ow.ost_modyfikacja = Time.now
    @ow.save
    redirect_to edit_pytanie_url(:id => @ow.id_pyt), notice: 'Pytanie zapisane.'
  end

  def destroy
    @ow = OdpowiedzWzorcowa.where("tresc_odp = ? AND id_pyt = ?", params[:odpowiedz_wzorcowa][:tresc_odp] , params[:odpowiedz_wzorcowa][:id_pyt])[0]
    @ow.destroy
    redirect_to edit_pytanie_url(:id => @ow.id_pyt), notice: 'Pytanie usuniete.'
  end
end
