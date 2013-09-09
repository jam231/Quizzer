class RankingController < ApplicationController
  def index
#    session[:user_id] = 1


    @ranking = Ranking.where(:id_grupy => params[:id_grupy]).order("pkt DESC")

    @grupa = GrupaQuizowa.find(params[:id_grupy])

  end

  def reset_session
    session[:pytania] = {}
  end

end
