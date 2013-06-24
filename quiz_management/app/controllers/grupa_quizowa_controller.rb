class GrupaQuizowaController < ApplicationController
  before_filter :available?

  helper_method :has_privilege?

  def index
    quizzes
  end

  def show
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
    render 'index'
  end



  private

  #
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

  # Domyslnie wysyłamy, jakis symbol (lub cos, do omowienia co to bedzie i co bedzie znaczylo.)
  # a ta helper_function sprawdza, czy current_user (tez helper function, tylko innego kontrolera)
  # ma zadane argumentem uprawnienie.
  # Przyda sie przy zabawach tworzeniem grup/quizow, etc.
  def has_privilege?(pivilege_name)
    true
  end
end
