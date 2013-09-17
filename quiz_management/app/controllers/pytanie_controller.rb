# encoding: UTF-8

class PytanieController < ApplicationController
	include GrupaQuizowaHelper
	include QuizHelper
	include PytanieHelper

	before_filter :logged?, :group_available?, :quiz_available?
	before_filter :pytanie_available?, :except => [:create]
  before_filter :has_quiz_modify_privilege?, :only => [:create, :edit, :update, :destroy]

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
    logger.debug "#{@pytanie.inspect} ........ #{@params.inspect}"
    logger.debug "#{@pytanie.errors.inspect}"
    if @pytanie.errors.any?
      redirect_to pytanie_edit_url(:id => @pytanie.id_pyt), alert: "Pytanie nie zapisane.\n" + @pytanie.errors.messages.values.join("\n")
    else
      redirect_to pytanie_edit_url(:id => @pytanie.id_pyt), notice: 'Pytanie zapisane.'
    end
  end

  def destroy
    @pytanie = Pytanie.find(params[:id_pyt])
    @pytanie.destroy
    redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie usunięte.'
  end

  def pokaz_lub_ukryj(id_pyt = nil)
    id_pyt ||= params[:id_pyt]
    @pytanie = Pytanie.find(id_pyt)
    if @pytanie.poprawne? || (@pytanie.ukryte == false)
      @pytanie.ukryte = (!@pytanie.ukryte)
      @pytanie.save
      redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie zapisane.'
    else
      redirect_to quiz_edit_url(:id => @pytanie.id_quizu), alert: 'Operacja się nie udała!<br>Sprawdź czy pytanie ma wszystkie odpowiedzi'
    end
  end

end
