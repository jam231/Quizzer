# encoding: UTF-8

module PytanieHelper
	def score_tag(points_for_answer, points_for_question)
		content_tag :i, "(#{points_for_answer} / #{points_for_question} punktów)",
		                :class => score_tag_class(points_for_answer, points_for_question)
	end

	def score_tag_class(score, max_score)
		mediocre_points = 0.75 * max_score
		bad_points = 0.25 * max_score

		tag_class = "good-score"
		tag_class = "mediocre-score" if score < mediocre_points
		tag_class = "bad-score" if score < bad_points

		tag_class
	end

	def pytanie_available?
		begin
			quiz = Quiz.find(params[:id_quizu])
			pytanie = Pytanie.find(params[:id_pyt])
			unless pytanie.id_quizu == quiz.id_quizu
					redirect_to quiz_edit_url(:id_grupy => quiz.id_grupy, :id_quizu => quiz.id_quizu), :alert => "Pytanie nie jest dostępne w quizie."
			end
		rescue ActiveRecord::RecordNotFound
			redirect_to quiz_edit_url(:id_grupy => quiz.id_grupy, :id_quizu => quiz.id_quizu), :alert => "Pytanie nie jest dostępne."
		end
	end
end
