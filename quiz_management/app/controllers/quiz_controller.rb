class QuizController < ApplicationController
  def index
    session[:user_id] = 1


    @quiz = Quiz.find(params[:id])

    session[:pytania] ||= Hash.new

    for pytanie in @quiz.pytania do
      session[:pytania][pytanie.id_pyt] ||= pytanie.r_odpowiedzi
      puts session[:pytania][pytanie.id_pyt].class
    end
    #@pytania = Pytanie.where("id_quizu = ?", params[:id])
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def submit
    date = Time.now.strftime("%F %T.%L")

    @quiz = Quiz.find(params[:id])

    @quiz.pytania.each { |pytanie|
      odp = OdpowiedzUzytkownika.new
      odp.id_uz = session[:user_id]
      odp.id_pyt = pytanie.id_pyt
      odp.data_wyslania = date

      if pytanie.otwarte?
        odp.tresc_odp = params[:odpowiedzi][pytanie.id_pyt.to_s] || 'nil'
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

    }
    params.merge!(:date_submitted => date)

    redirect_to quiz_path(params)
  end

  def checked?(question_id, answer)
    params[:odpowiedzi][question_id.to_s].include? answer if params[:odpowiedzi]
  end

  def points_for_question(question_id, time)
    #hurray for niekonsekwencja jezykowa
    OdpowiedzUzytkownika.punkty(session[:user_id], question_id, time)
  end

  def reset_session
    session[:pytania] = {}
  end

  def comments(question_id)
    comment = ''

    session[:pytania][question_id].each { |odpowiedz|
      comment += odpowiedz.komentarz.to_s if checked?(question_id, odpowiedz.tresc_odp.to_s)
    }
    comment = 'Komentarz: ' + comment if comment.length > 0
  end
end
