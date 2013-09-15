# encoding: UTF-8
module LimboHelper
	def can_access_limbo?
		if logged?
			if current_user.superuser?
				true
			else
				redirect_to root_url, :alert => "Brak dostepu do tej grupy."
			end
		end
		false
	end
end
