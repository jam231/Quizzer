# encoding: UTF-8

class GrupaQuizowaController < ApplicationController
  include GrupaQuizowaHelper

	before_filter :logged?
  before_filter :group_available?, :except => [:index, :new, :create]
  before_filter :can_create_groups?, :only => [:new, :create]
  before_filter :can_delete_user?, :only => [:delete_user]

  helper_method :active?

  def index
		# ruby i inne sensownie jezyki programowania <3
	  @grupy =
		unless current_user.superuser?
			GrupaQuizowa.scoped.reject do |grupa|
				grupa.limbo? or
				(!!(grupa.na_zaproszenie) and grupa.grupa_dostep.where(:id_uz => current_user.id_uz).blank?)
			end
		else
			GrupaQuizowa.scoped.reject { |grupa| grupa.limbo? }
		end
	end

  def show
		quizzes
  end

  def new
		@grupa = GrupaQuizowa.new
  end

  def create
		logger.debug "#{params[:grupa_quizowa]}"
	  @grupa = GrupaQuizowa.new params[:grupa_quizowa].merge :wlasciciel => current_user

	  if @grupa.save
		  redirect_to grupa_public_url, :notice => "Grupa #{@grupa.nazwa} została pomyślnie stworzona."
	  else
		  alert_msg = ''
		  alert_msg = @grupa.errors.messages.values.first.first.to_s if @grupa.errors.any?
		  redirect_to grupa_new_url, :alert => alert_msg
	  end
  end

  def quizzes
    @quizzes = @grupa.quizzes.all
    @what = 'quizzes'
    render 'show'
  end

  def users
    @users = Uzytkownik.find(@grupa.dostep_grupa.where("id_uz <> 1").select(:id_uz).uniq.all.map(&:id_uz))
    @what = 'users'
    render 'show'
  end

  def ranking
    @what = 'ranking'
    @ranking = Ranking.where(:id_grupy => @grupa.id_grupy).order("pkt DESC")
    render 'show'
  end

  # DELETE
  def delete_user
		user = Uzytkownik.find(params[:id_uz])
		@grupa.wypisz_uzytkownika! user
		redirect_to :back, :notice => "Użytkownik #{user.nazwa_uz} został wypisany z grupy #{@grupa.nazwa}."
  end

  protected

  def active?(what)
    case what
      when :quizy
        @what == 'quizzes'
      when :ranking
        @what == 'ranking'
      when :uzytkownicy
        @what == 'users'
      else
        false
    end
  end
end

