# encoding: UTF-8

class GrupaQuizowaController < ApplicationController
  include GrupaQuizowaHelper

	before_filter :logged?, :group_available?

  helper_method :active?

  def index
    quizzes
  end

  def new
  end

  def create
  end

  def quizzes
    @quizzes = @grupa.quizzes.all
    @what = 'quizzes'
    render 'index'
  end

  def users
    @users = Uzytkownik.find(@grupa.dostep_grupa.where("id_uz <> 1").select(:id_uz).uniq.all.map(&:id_uz))
    @what = 'users'
    render 'index'
  end

  def ranking
    @what = 'ranking'
    @ranking = Ranking.where(:id_grupy => @grupa.id_grupy).order("pkt DESC")
    render 'index'
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

