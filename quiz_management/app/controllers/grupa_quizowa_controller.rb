class GrupaQuizowaController < ApplicationController
  before_filter :available?
  def index
    @what = 'quizzes'
    # Grupa istnieje, badz nie.
  end

  def show
  end

  def new
  end

  def create
  end

  def quizzes
    @what = 'quizzes'
    render 'index'
  end

  def users
    begin
      @grupa = GrupaQuizowa.find(params[:id])
      @id_grupy = params[:id]
    rescue
      #redirect_to :back, :notice => "Grupa nie istnieje."
      render :text => "Grupa nie istnieje."
      return nil
    end
    # Uzytkownik jest zalogowany, or so I hope.
    if current_user
      user_from_grupa_dostep = @grupa.dostep_grupa.where(:id_uz => current_user.id)
      # Uzytkownik ma jakies prawa w danej grupie.
      if user_from_grupa_dostep
        @user_privileges = user_from_grupa_dostep.first.prawa_dost
        @what = 'users'
        render 'index'
      else
        #redirect_to :back, :notice => "Brak dostepu do tej grupy."
        render :text => "Brak dostepu do tej grupy."
      end
    else
      redirect_to new_sessions_path, :notice => "Aby uzyksac dostep do grupy musisz sie zalogowac"
      #render :text => "Musisz sie zalogowac"
    end
  end

  def ranking
    @what = 'ranking'
    render 'index'
  end



  private

  def available?
    begin
      @grupa = GrupaQuizowa.find(params[:id])
      @id_grupy = params[:id]
    rescue
      #redirect_to :back, :notice => "Grupa nie istnieje."
      render :text => "Grupa nie istnieje."
      return nil
    end
    # Uzytkownik jest zalogowany, or so I hope.
    if current_user
      user_from_grupa_dostep = @grupa.dostep_grupa.where(:id_uz => current_user.id)
      # Uzytkownik ma jakies prawa w danej grupie.
      if user_from_grupa_dostep
        @user_privileges = user_from_grupa_dostep.first.prawa_dost
      else
        #redirect_to :back, :notice => "Brak dostepu do tej grupy."
        render :text => "Brak dostepu do tej grupy."
      end
    else
      redirect_to new_sessions_path, :notice => "Aby uzyksac dostep do grupy musisz sie zalogowac"
      #render :text => "Musisz sie zalogowac"
    end
  end

end
