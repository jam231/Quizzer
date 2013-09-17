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
    @pytanie ||= Pytanie.find(id_pytania)
  end

  def create
    # ohydne. biję się w pierś
    logger.debug "Tworzenie pytania: #{params.inspect}"
    @pytanie = Pytanie.new
    @pytanie.tresc = "Nowe pytanie z #{Time.now.to_s}"
    @pytanie.id_autora = session[:user_id]
    @pytanie.id_quizu  = params[:id_quizu]
    @pytanie.id_typu = 1      #bonus points for hardcoding
    @pytanie.id_kategorii = 1
    @pytanie.save

    redirect_to pytanie_edit_url(@pytanie, :id_pyt => @pytanie.id_pyt,
                                           :id_quizu => params[:id_quizu],
                                           :id_grupy => params[:id_grupy]),
                notice: 'Pytanie utworzone.'
  end

  def update
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.update_attributes(params[:pytanie].except(:id_pyt))
    @pytanie.ukryty = true unless @pytanie.poprawne?
    @pytanie.save

    logger.debug "Aktualizacja pytania: #{@pytanie.inspect} Parametry: #{@params.inspect}"
    logger.debug "Błędy: #{@pytanie.errors.inspect}"
    if @pytanie.errors.any?
      redirect_to pytanie_edit_url(:id => @pytanie.id_pyt), alert: "Pytanie nie zapisane." + @pytanie.errors.messages.values.join("<br>")
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
    if @pytanie.poprawne? or  not @pytanie.ukryty
      @pytanie.ukryty = (!@pytanie.ukryty)
      @pytanie.save
      redirect_to quiz_edit_url(:id => @pytanie.id_quizu), notice: 'Pytanie zapisane.'
    else
      redirect_to quiz_edit_url(:id => @pytanie.id_quizu), alert: 'Operacja się nie udała!<br>Sprawdź czy pytanie ma wszystkie odpowiedzi'
    end
  end

end
