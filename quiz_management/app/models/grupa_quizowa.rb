# encoding: UTF-8
  class GrupaQuizowa < ActiveRecord::Base
    self.table_name = 'grupa_quizowa'
    self.primary_key = :id_grupy

    after_initialize :default_value_for_na_zaproszenie

    has_many :dostep_grupa, :foreign_key => 'id_grupy', :class_name => "DostepGrupa"
    has_many :quizzes, :foreign_key => 'id_grupy', :class_name =>  "Quiz"
    belongs_to :wlasciciel, :foreign_key => 'id_wlasciciela', :class_name => "Uzytkownik"

    @@privileges = {:participation_in_quizzes => 1 << 15,
                    :participation_in_discussions => 1 << 14,
                    :creation_of_quizzes => 1 << 13,
                    :editing_and_deleting_quizzes => 1 << 12,
                    :editing_and_deleting_discussions => 1 << 11,
                    :access_to_group => 0}

    attr_accessible :nazwa, :wlasciciel, :password, :password_confirmation, :na_zaproszenie

    attr_accessor :password
    before_save :encrypt_password

    validates :id_wlasciciela, :presence => true, :length => {:maximum =>  60}
    validates :nazwa, :presence => true, :uniqueness => true, :length => {:maximum =>  60}
    validates :password, :length => {:in => 0..30}, :on => :create
    validates_confirmation_of :password


    def encrypt_password
	    logger.debug "Hashuje haslo #{password}."
	    if password.present?
		    self.haslo_salt = BCrypt::Engine.generate_salt
		    logger.debug "Wygenerowany salt = #{haslo_salt}."
		    self.haslo = BCrypt::Engine.hash_secret(password, haslo_salt)
		    logger.debug "Hash = #{self.haslo}."
	    end
    end

    def authenticate password
	    logger.debug "Uzyskiwanie dostępu do grupy #{self.nazwa}"
	    logger.debug "Podane haslo to #{password}, salt to #{self.haslo_salt}."
	    logger.debug "Hash = #{BCrypt::Engine.hash_secret(password, self.haslo_salt)}"

	    self.password_protected? or self.haslo == BCrypt::Engine.hash_secret(password, self.haslo_salt)
    end


    def limbo?
			self.id_grupy == 0
    end

    def self.Limbo
			GrupaQuizowa.find 0
    end

    def owner? user
	    id_uz = if user.is_a? Integer then user else user.id_uz end
			self.wlasciciel.id_uz == id_uz
    end

    def password_protected?
			not self.haslo.blank?
    end

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

	    logger.debug "Czy użytkownik #{user.nazwa_uz} ma przywileje #{privileges} ?"

	    dostep_grupa = self.dostep_grupa.where(["id_uz = ?", user.id_uz]).first

	    logger.debug "Czy użytkownik #{user.nazwa_uz} ma dostęp do grupy #{self.nazwa} ? : #{dostep_grupa != nil}."
			user.superuser? or self.owner? user or (dostep_grupa && dostep_grupa.prawa_dost.to_i(2) & privileges == privileges)
    end

    def public?
			self.id_grupy == 1
    end

    def self.Public
			GrupaQuizowa.find(1)
    end

    def zapisany? user
	    not self.dostep_grupa.where(:id_uz => user.id_uz).blank?
    end

    def wypisz_uzytkownika! user
	    id_uz = if user.is_a? Integer then user else user.id_uz end
		  query = ActiveRecord::Base.send :sanitize_sql_array, ["select * from wypisz_uzytkownika_z_grupy(%s, %s)", id_uz, self.id_grupy]
		  query_results = self.connection.execute(query)
    end

    def zapisz_uzytkownika! user
	    id_uz = if user.is_a? Integer then user else user.id_uz end
	    logger.debug "Zapisz użytkownka o id = #{id_uz} do grupy o id = #{self.id_grupy}."
	    query = ActiveRecord::Base.send :sanitize_sql_array, ["select * from zapisz_uzytkownika_do_grupy(%s, %s)", id_uz, self.id_grupy]
	    query_results = self.connection.execute(query)
    end

    private
    def default_value_for_na_zaproszenie
	    self.na_zaproszenie ||= false
    end

  end

