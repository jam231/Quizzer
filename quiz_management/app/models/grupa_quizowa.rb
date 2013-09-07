  class GrupaQuizowa < ActiveRecord::Base
    self.table_name = 'grupa_quizowa'
    self.primary_key = :id_grupy

    has_many :dostep_grupa, :foreign_key => 'id_grupy', :class_name => "DostepGrupa"
    has_many :quizzes, :foreign_key => 'id_grupy', :class_name =>  "Quiz"

    @@privileges = {:participation_in_quizzes => 1 << 13,
                    :participation_in_discussions => 1 << 12,
                    :creation_of_quizzes => 1 << 11,
                    :editing_and_deleting_quizzes => 1 << 10,
                    :editing_and_deleting_discussions => 1 << 9,
                    :access_to_group => 0}

    def has_privileges?(user, *privilege_names)
	    # Przeklejone z modelu fizycznego:
	    #  --SPECYFIKACJA PRAW DOSTEPU OD NAJWIEKSZEGO BITU (get_bit, rzutowanie dziala od najw.):
	    #  --uczestnictwo w quizach
	    #  --uczestnictwo w dyskusji
	    #  --tworzenie quizow
	    #  --modyfikacja i usuwanie quizow
	    #  --modyfikacja i usuwanie w dyskusji

	    privileges = 0
	    for privilege_name in privilege_names
				privileges |= @@privileges.fetch(privilege_name, 1)
			end

	    logger.debug "Czy uzytkownik #{user.nazwa_uz} ma przywileje #{privileges} ?"

	    # Nad tym ponizej moznaby sie zastanowic, np. czy nie lepiej byloby zapewnic to w bazie.
		  is_superuser = !(user.ranga =~ /u.ytkownik.*/)

	    logger.debug "Czy uzytkownik #{user.nazwa_uz} jest superuzytkownikiem ? : #{is_superuser} "

	    dostep_grupa = self.dostep_grupa.where(["id_uz = ?", user.id_uz]).first

	    logger.debug "Czy uzytkownik #{user.nazwa_uz} ma dostep do grupy #{self.nazwa} ? : #{dostep_grupa != nil}"
			is_superuser || (dostep_grupa && dostep_grupa.prawa_dost.to_i(2) & privileges == privileges)
    end

  end

