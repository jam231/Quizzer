class PytanieController < ApplicationController
  def edit
    @pytanie = Pytanie.find(params[:id] || params[:pytanie][:id_pyt])
    @nowa_odpowiedz = OdpowiedzWzorcowa.new(:id_pyt => params[:id])
    @nowa_odpowiedz.tresc_odp = 'Nowa odpowiedz'
  end

  def create
    @pytanie = Pytanie.new(params[:pytanie])
    @pytanie.id_autora = session[:user_id]
    @pytanie.save
    redirect_to edit_quiz_url(:id => @pytanie.id_quizu), notice: 'Pytanie zapisane.'
  end

  def update
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.update_attributes(params[:pytanie].except(:id_pyt))
    @pytanie.save
    puts @pytanie.inspect, @params.inspect
    redirect_to edit_pytanie_url(:id => @pytanie.id_pyt), notice: 'Pytanie zapisane.'
  end

  def destroy
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.destroy
    redirect_to edit_quiz_url(:id => @pytanie.id_quizu), notice: 'Pytanie usuniete.'
  end

end
