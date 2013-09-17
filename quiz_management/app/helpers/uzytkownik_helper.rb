# encoding: UTF-8
module UzytkownikHelper
	def can_edit?
		begin
		  user = Uzytkownik.find params[:id_uz]
			redirect_to root_url, :alert => "Nie masz odpowiednich uprawnień." unless current_user.id_uz == user.id_uz or current_user.superuser?
		rescue ActiveRecord::RecordNotFound
			redirect_to root_url, :alert => "Użytkownik nie istnieje."
		end
	end
end
