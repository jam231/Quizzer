# encoding: UTF-8
module GrupaQuizowaHelper

  def can_create_groups?
		 redirect_to grupy_url, :alert => "Brak uprawnień do tworzenia nowej grupy." unless current_user.can_create_new_groups?
  end

  def can_delete_user?
		begin
			grupa = GrupaQuizowa.find params[:id_grupy]
			user = Uzytkownik.find params[:id_uz]
			redirect_to :back, :alert => "Użytkownik #{user.nazwa_uz} nie jest zapisany do grupy #{grupa.nazwa}." unless grupa.zapisany? user
			# redirect_to :back, :alert => "Nie można wypisać z grupy public." if grupa.public?
			redirect_to :back, :alert => "Nie można wypisać właściciela." if grupa.owner? user
			redirect_to :back, :alert => "Brak odpowiednich przywilejów." unless grupa.has_privileges user, :deleting_users or user.id_uz == current_user.id_uz
		rescue ActiveRecord::RecordNotFound
			redirect_to :back, :alert => "Użytownik #{user.nazwa_uz} nie istnieje."
		end
  end


	def group_available?
		begin
			@grupa = GrupaQuizowa.find params[:id_grupy]
			user_from_grupa_dostep =  @grupa.dostep_grupa.where :id_uz => current_user.id_uz
			# To ponizej wypadaloby zrefaktorowac.
			if user_from_grupa_dostep.empty?
			  unless @grupa.na_zaproszenie
					@grupa.zapisz_uzytkownika! current_user
					flash[:notice] = "Zostałeś zapisany do grupy #{@grupa.nazwa}"
				else
					redirect_to root_url, :alert => "Brak dostepu do grupy #{@grupa.nazwa}."
				end
			end
		rescue ActiveRecord::RecordNotFound
			redirect_to root_url, :alert => "Grupa nie istnieje."
		end
	end

	def has_access_to_quiz?
		has_quiz_privilege? :participation_in_quizzes
	end

	def has_quiz_destroy_privilege?
		has_quiz_privilege? :editing_and_deleting_quizzes
	end

	def has_quiz_modify_privilege?
		has_quiz_privilege? :editing_and_deleting_quizzes
	end

	def has_quiz_creation_privilege?
		grupa_quizowa = GrupaQuizowa.find(params[:id_grupy])
		grupa_quizowa.has_privileges? current_user, :creation_of_quizzes
	end

	def has_quiz_privilege?(privilege_name, privilege_violation_message = 'Uzytkownik nie ma odpowiednich uprawnień w tej grupie.')
		user = current_user
		grupa_quizowa = GrupaQuizowa.find(params[:id_grupy])
		quiz = Quiz.find(params[:id_quizu])

		logger.debug "Czy uzytkownik #{user.nazwa_uz} ma odpowiednie uprawnienia do quizu #{quiz.nazwa} {:id_quizu => #{quiz.id_quizu}}} ? "

		unless grupa_quizowa.has_privileges? user, privilege_name

			logger.debug "Uzytkownik #{user.nazwa_uz} nie ma odpowiednich uprawnien do quizu #{quiz.nazwa} {:id_quizu => #{quiz.id_quizu}}. "

			redirect_to grupa_url(:id_grupy => grupa_quizowa.id_grupy), :alert =>  privilege_violation_message
		else
			logger.debug "Tak, użytkownik ma odpowiednie uprawnienia."
		end
	end
end
