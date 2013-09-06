  class GrupaQuizowa < ActiveRecord::Base
    self.table_name = 'grupa_quizowa'
    self.primary_key = :id_grupy

    has_many :dostep_grupa, :foreign_key => 'id_grupy', :class_name => "DostepGrupa"
    has_many :quizzes, :foreign_key => 'id_grupy', :class_name =>  "Quiz"

    @@privileges = {:participation_in_quizzes => 1 << 13,
                    :participation_in_discussions => 1 << 12,
                    :creation_of_quizzes => 1 << 11,
                    :editing_quizzes => 1 << 10,
                    :editing_discussions => 1 << 9}

    def has_privilege?(user, privilege_name)
	    # Przeklejone z modelu fizycznego:
	    #  --SPECYFIKACJA PRAW DOSTEPU OD NAJWIEKSZEGO BITU (get_bit, rzutowanie dziala od najw.):
	    #  --uczestnictwo w quizach
	    #  --uczestnictwo w dyskusji
	    #  --tworzenie quizow
	    #  --modyfikacja i usuwanie quizow
	    #  --modyfikacja i usuwanie w dyskusji
	    !(user.ranga =~ /u.ytkownik.*/)
	    #
	    # @@privileges.fetch(privilege_name, 1) == @user_privileges.to_i & @@privileges.fetch(privilege_name)
    end

  end

