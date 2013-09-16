# encoding: UTF-8
module QuizHelper
	def quiz_available?
		begin
			quiz = Quiz.find(params[:id_quizu])
			grupa_quizowa = GrupaQuizowa.find(params[:id_grupy])
			unless grupa_quizowa.id_grupy == quiz.id_grupy
				redirect_to grupa_url(:id_grupy => grupa_quizowa.id_grupy), :alert => "Quiz nie jest dostępny w grupe."
			end
		rescue ActiveRecord::RecordNotFound
			redirect_to grupa_url(:id_grupy => grupa_quizowa.id_grupy), :alert => "Quiz nie jest dostępny."
		end
	end
end
