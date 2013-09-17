# encoding: UTF-8
class QuizController < ApplicationController
	include GrupaQuizowaHelper
	include QuizHelper

	before_filter :logged?, :group_available?
	before_filter :quiz_available?, :except => [:new, :create]
	before_filter :has_access_to_quiz?, :only => [:info, :index]
	before_filter :has_quiz_creation_privilege?, :only => [:new, :create]
	before_filter :has_quiz_modify_privilege?, :only => [:activate, :edit, :update]
	before_filter :has_quiz_destroy_privilege?, :only => [:destroy]


  def index

    logger.info "Użytkownik #{current_user.nazwa_uz} {id_uz => #{current_user.id_uz} }"

    @quiz = Quiz.find(params[:id_quizu])

    session[:pytania] ||= Hash.new

    logger.info "Id quizu = #{@quiz.id_quizu}"

    for pytanie in @quiz.pytania do

			logger.debug "Id pytania = #{pytanie.id_pyt}"
      session[:pytania][pytanie.id_pyt] ||= pytanie.r_odpowiedzi
      puts session[:pytania][pytanie.id_pyt].class

    end
  end

	# GET - wygeneruj formularz do tworzenia quizu
	def new
		redirect_to :back, :alert => "Not implemented yet."
	end

	# POST - zwaliduj otrzymany formularz, nastepnie zapisz quiz lub przekieruj do new z zaznaczonymi bledami.
	def create
		redirect_to :back, :alert => "Not implemented yet."
	end

	# PUT
	def activate
		quiz = Quiz.find params[:id_quizu]
		quiz.ukryty = false
		quiz.save
		redirect_to grupa_url, :notice => "Quiz #{quiz.nazwa} został udostepniony grupie."
	end

	# PUT
	def deactivate
		quiz = Quiz.find params[:id_quizu]
		quiz.ukryty = true
		quiz.save
		redirect_to grupa_url, :notice => "Quiz #{quiz.nazwa} został ukryty."
	end

  def info
	  @quiz = Quiz.find(params[:id_quizu])
	  logger.debug  @quiz.podejscia_uzytkownika(current_user)
		@attempts = @quiz.podejscia_uzytkownika(current_user).map do |dict|
			[dict[:zdobyte_pkt], dict[:max_pkt], dict[:data_wyslania]]
		end
	  #logger.info "Użytkownik #{current_user.nazwa_uz} chce uzyskac informacje o quizie #{@quiz.data_utworzenia} {id => #{@quiz.id_quizu}}."
  end

  def destroy
	quiz = Quiz.find(params[:id_quizu])
	if quiz.destroy
		logger.info "Quiz #{quiz.nazwa} {:id => #{quiz.id_quizu}} został usunięty przez użytkownika #{current_user.nazwa_uz}."
		flash[:notice] = "Quiz #{quiz.nazwa} został usunięty."
	else
		flash[:alert] = "Usunięcie quizu się nie powiodło."
	end
	redirect_to grupa_url
  end

  def edit
    @quiz = Quiz.find(params[:id_quizu])
    @grupa = GrupaQuizowa.find(params[:id_grupy])
  end

  def submit
    date = Time.now.strftime("%F %T.%L")

    @quiz = Quiz.find(params[:id_quizu])

    @quiz.pytania.each do |pytanie|
      odp = OdpowiedzUzytkownika.new
      odp.id_uz = session[:user_id]
      odp.id_pyt = pytanie.id_pyt
      odp.data_wyslania = date

      if pytanie.otwarte?
        odp.tresc_odp = params[:odpowiedzi][pytanie.id_pyt.to_s] || "nil"
        odp.zaznaczona = true
        odp.save!
      else
        session[:pytania][pytanie.id_pyt].each { |odpowiedz|
          #hurray for code duplication
          odp = OdpowiedzUzytkownika.new
          odp.id_uz = session[:user_id]
          odp.id_pyt = pytanie.id_pyt
          odp.data_wyslania = date

          odp.tresc_odp = odpowiedz.tresc_odp
          odp.zaznaczona = checked?(pytanie.id_pyt, odpowiedz.tresc_odp)
          odp.save!
        }
      end
    end

    Ranking.przelicz_ranking! @quiz.grupa_quizowa

    params.merge!(:date_submitted => date)

    redirect_to quiz_url(params)
  end

  def checked?(question_id, answer)
    if params[:odpowiedzi]
      if params[:odpowiedzi][question_id.to_s]
        params[:odpowiedzi][question_id.to_s].include? answer
      else
        false
      end
    else
      false
    end
  end

  def reset_session
    session[:pytania] = {}
  end

  def comments(question_id)
    comment = ''

    session[:pytania][question_id].each { |odpowiedz|
      comment += odpowiedz.komentarz.to_s if checked?(question_id, odpowiedz.tresc_odp.to_s)
    }
    comment = "Komentarz: #{comment}" if comment.length > 0
  end
end
