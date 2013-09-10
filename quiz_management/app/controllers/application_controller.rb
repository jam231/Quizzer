class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :group_available?, :has_access_to_quiz?, :has_quiz_modify_privilege?,
                :has_quiz_creation_privilege?, :has_quiz_destroy_privilege?

  def current_user
	  @current_user ||= Uzytkownik.find(session[:user_id]) if session[:user_id]
  end

  def logged?
		if current_user.nil?
			redirect_to log_in_url, :alert => "Aby uzyskac dostep do grupy musisz sie zalogowac"
			false
		end
		true
  end

  def group_available?
	  begin
		  @grupa = GrupaQuizowa.find(params[:id_grupy])
		  @id_grupy = params[:id]
	  rescue
		  redirect_to root_url, :alert => "Grupa nie istnieje."
		  return false
	  end
	  # Uzytkownik jest zalogowany, or so I hope.
	  if current_user
		  user_from_grupa_dostep = @grupa.dostep_grupa.where(:id_uz => current_user.id)
		  # Uzytkownik ma jakies prawa w danej grupie.
		  if user_from_grupa_dostep
			  @user_privileges = user_from_grupa_dostep.first.prawa_dost
				return true # Let 'em pass.
		  else
			  #redirect_to :back, :notice => "Brak dostepu do tej grupy."
			  redirect_to root_url, :alert => "Brak dostepu do tej grupy."
		  end
	  else
		  redirect_to log_in_url, :alert => "Aby uzyskac dostep do grupy musisz sie zalogowac"
	  end
		false # User has failed.
  end

  def has_access_to_quiz?
	  if group_available?
		  has_quiz_privilege? :participation_in_quizzes
	  else
		  false
	  end
  end

  def has_quiz_destroy_privilege?
	  if group_available?
		  has_quiz_privilege? :editing_and_deleting_quizzes
	  else
		  false
	  end
  end

  def has_quiz_modify_privilege?
	  if group_available?
		  has_quiz_privilege? :editing_and_deleting_quizzes
	  else
		  false
	  end
  end

  def has_quiz_creation_privilege?
	  if group_available?
		  grupa_quizowa = GrupaQuizowa.find(params[:id_grupy])
		  grupa_quizowa.has_privileges? current_user, :creation_of_quizzes
	  else
		  false
	  end
  end

  def has_quiz_privilege?(privilege_name, privilege_violation_message = 'Uzytkownik nie ma odpowiednich uprawnien dla tego quizu.')
	  #begin
		  user = current_user
		  quiz = Quiz.find(params[:id_quizu])
		  logger.debug "Czy uzytkownik #{user.nazwa_uz} ma odpowiednie uprawnienia do quizu #{quiz.nazwa} {:id_quizu => #{quiz.id_quizu}} ? "
		  grupa_quizowa = GrupaQuizowa.find(params[:id_grupy])
		  logger.debug "Grupa quizowa #{grupa_quizowa.nazwa}"
		  if grupa_quizowa.id_grupy == quiz.id_grupy
			  unless grupa_quizowa.has_privileges?(user, privilege_name)
				  logger.debug "Uzytkownik #{user.nazwa_uz} nie ma odpowiednich uprawnien do quizu #{quiz.nazwa} {:id_quizu => #{params[:id_quizu]}}. "
				  redirect_to grupa_url(:id_grupy => params[:id_grupy]), :alert =>  privilege_violation_message
			  else
					logger.debug "Tak"
			  end
		  else
			  logger.debug "Quiz #{quiz.nazwa} {:id_quizu => #{params[:id_quizu]}} nie nalezy do grupy #{grupa_quizowa.nazwa} {:id_grupy => #{grupa_quizowa.id_grupy}} "
			  redirect_to grupa_url(:id_grupy => params[:id_grupy]), :alert => 'Quiz jest niedostepny w tej grupie.'
		  end
	  #rescue
		  #raise ActionController::RoutingError.new('Not Found')
	  #end
  end
	
end
