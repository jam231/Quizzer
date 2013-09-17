# encoding: UTF-8
module QuizHelper
	def quiz_available?
		begin
			grupa_quizowa = GrupaQuizowa.find(params[:id_grupy])
			quiz = Quiz.find(params[:id_quizu])
			unless grupa_quizowa.id_grupy == quiz.id_grupy and not quiz.ukryty
				redirect_to grupa_url(grupa_quizowa), :alert => "Quiz nie jest dostępny w grupie."
			end
		rescue ActiveRecord::RecordNotFound
			redirect_to grupa_url(grupa_quizowa), :alert => "Quiz nie jest dostępny."
		end
	end
end
