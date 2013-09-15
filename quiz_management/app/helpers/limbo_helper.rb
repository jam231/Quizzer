# encoding: UTF-8
module LimboHelper
	def can_access_limbo?
		redirect_to root_url, :alert => "Brak dostepu do tej grupy."  unless current_user.superuser?
	end

	def quiz_in_limbo?
		quiz = Quiz.find(params[:id_quizu])
		unless (quiz.id_grupy || GrupaQuizowa.Limbo.id_grupy + 1) == GrupaQuizowa.Limbo.id_grupy
			redirect_to grupa_limbo_url, :alert => "Quizu od id = #{params[:id_quizu]} nie ma w Limbo."
		end
	end
end
