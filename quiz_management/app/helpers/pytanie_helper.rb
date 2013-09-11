# encoding: UTF-8

module PytanieHelper
	def score_tag(points_for_answer, points_for_question)
		mediocre_points = 0.75 * points_for_question
		bad_points = 0.25 * points_for_question

		tag_class = "good-score"
		tag_class = "mediocre-score" if points_for_answer < mediocre_points
		tag_class = "bad-score" if points_for_answer < bad_points

		content_tag :i, "(#{points_for_answer} / #{points_for_question} punktów)", :class => tag_class
	end
end
