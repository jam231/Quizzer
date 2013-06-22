class QuizController < ApplicationController
  def index
    @quiz = Quiz.find(params[:id])
    #@pytania = Pytanie.where("id_quizu = ?", params[:id])
  end
end
