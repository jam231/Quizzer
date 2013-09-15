# encoding: UTF-8
class LimboController < ApplicationController
		include LimboHelper

		before_filter :can_access_limbo?

		helper_method :active?

		def index
			@limbo = GrupaQuizowa.Limbo
			quizzes
		end

		def show
		end

		def quizzes
			@limbo = GrupaQuizowa.Limbo
			@quizzes = @limbo.quizzes.all
			render :template => 'limbo/index', :locals => {:what => 'quizzes'}
		end

		def moderators
			@limbo = GrupaQuizowa.Limbo
			@moderators = Uzytkownik.scoped.select {|uzytkownik| uzytkownik.superuser? and not uzytkownik.limbo?}
			render :template => 'limbo/index', :locals => {:what => 'moderators'}
		end

		# GET
		def quiz_authorship
			@limbo = GrupaQuizowa.Limbo
			@users = Uzytkownik.scoped.select {|uzytkownik| not (uzytkownik.superuser? or uzytkownik.limbo?) }
			render :template => 'limbo/index', :locals => {:what => 'quiz_authorship'}
		end

		# DELETE
		def delete_user_answers
			redirect_to grupa_limbo_url, :alert => 'Not implemented yet.'
		end

		# GET
		def quiz_group_transfer_form
			@limbo = GrupaQuizowa.Limbo
			@groups = GrupaQuizowa.scoped.select {|grupa| not grupa.limbo?}
			render :template => 'limbo/index', :locals => {:what => 'quiz_group_transfer_form'}
		end

		protected

		def active?(rendered, question)
			case question
				when :quizzes
					rendered == 'quizzes'
				when :transfer_quiz
					rendered == 'quiz_group_transfer_form'
				when :delete_user_answers
					rendered == 'delete_user_answers'
				when :transfer_authorship
					rendered == 'transfer_authorship'
				when :moderators
					rendered == 'moderators'
				else
					false
			end
		end
	end
