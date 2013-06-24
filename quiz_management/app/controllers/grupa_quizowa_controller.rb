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
      @grupa = GrupaQuizowa.find(params[:id_grupy])
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

  @@privileges = {:participation_in_quizzes => 1 << 13,
                :participation_in_discussions => 1 << 12,
                :creation_of_quizzes => 1 << 11,
                :editing_quizzes => 1 << 10,
                :edditing_discussions => 1 << 9}


  def has_privilege?(privilege_name)
    # Przeklejone z modelu fizycznego:
    #  --SPECYFIKACJA PRAW DOSTEPU OD NAJWIEKSZEGO BITU (get_bit, rzutowanie dziala od najw.):
    #  --uczestnictwo w quizach
    #  --uczestnictwo w dyskusji
    #  --tworzenie quizow
    #  --modyfikacja i usuwanie quizow
    #  --modyfikacja i usuwanie w dyskusji
    !(current_user.ranga =~ /u.ytkownik.*/)
    #
    # @@privileges.fetch(privilege_name, 1) == @user_privileges.to_i & @@privileges.fetch(privilege_name)
  end
end
