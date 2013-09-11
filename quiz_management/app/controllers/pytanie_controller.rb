# encoding: UTF-8

class PytanieController < ApplicationController
  def edit
    id_pytania = params[:id_pyt] || params[:id] || params[:pytanie][:id_pyt]
    @pytanie = Pytanie.find(id_pytania)
    @nowa_odpowiedz = OdpowiedzWzorcowa.new(:id_pyt => id_pytania)
    @nowa_odpowiedz.tresc_odp = 'Nowa odpowiedz'
  end

  def create
    @pytanie = Pytanie.new(params[:pytanie])
    @pytanie.id_autora = session[:user_id]
    @pytanie.save
    redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie zapisane.'
  end

  def update
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.update_attributes(params[:pytanie].except(:id_pyt))
    @pytanie.save
    puts @pytanie.inspect, @params.inspect
    redirect_to pytanie_edit_url(:id => @pytanie.id_pyt), notice: 'Pytanie zapisane.'
  end

  def destroy
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.destroy
    redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie usuniete.'
  end

end
