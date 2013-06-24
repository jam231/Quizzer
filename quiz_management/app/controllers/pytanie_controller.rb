class PytanieController < ApplicationController
  def edit
    reset_session
      @pytanie = Pytanie.find(params[:id_pyt])
  end

  def create
  end

  def update
    puts "-----------------------------/22/2/2/2/2/2/ #{params.inspect}"
    @pytanie = Pytanie.find(params[:pytanie][:id_pyt])
    @pytanie.update_attributes(params[:pytanie].except(:id_pyt))
    @pytanie.save
    redirect_to pytanie_edit_path(:id_pyt => @pytanie.id_pyt), notice: 'Pytanie zapisane.'
  end
end
