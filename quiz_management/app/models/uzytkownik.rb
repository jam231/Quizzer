# encoding: UTF-8
class Uzytkownik < ActiveRecord::Base

  self.table_name = 'uzytkownik'
  self.primary_key = :id_uz

  has_many :quizy, :foreign_key => 'id_wlasciciela', :class_name => "Quiz"
  has_many :grupy, :foreign_key => 'id_wlasciciela', :class_name => "GrupaQuizowa"
  has_many :dostep_grupa, :foreign_key => 'id_uz', :class_name => "DostepGrupa"



  validates :email, :presence => true, :uniqueness => true, :length => {:maximum =>  60},
            :format => {:with => /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
  validates :nazwa_uz, :presence => true, :uniqueness => true, :length => {:maximum => 30}
  validates :login, :presence => true, :uniqueness => true, :length => {:maximum => 15}
  validates :haslo, :presence => true, :length => {:in => 1..30}


  # Po co ?
  # Odsylam do http://blog.remarkablelabs.com/2012/12/strong-parameters-rails-4-countdown-to-2013
  attr_accessible :nazwa_uz, :login, :haslo, :email, :password, :ranga
  attr_accessor :password

  def limbo?
		self.id_uz == 0
  end

  def self.Limbo
		Uzytkownk.find(0)
  end

  def can_create_new_groups?
	  self.superuser? or self.teacher?
  end

  def self.authenticate(login, password)
    user = find_by_login(login)
    if user && user.haslo == password
      user
    else
      nil
    end
  end

  def normal_user?
		is_normal_user = (self.ranga == 'user')
		logger.debug "Czy użytkownik #{self.nazwa_uz} jest zwykłym użytkownikiem ? : #{is_normal_user} "
		is_normal_user
  end

  def teacher?
	  is_teacher = (self.ranga == 'teacher')
	  logger.debug "Czy użytkownik #{self.nazwa_uz} jest nauczycielem ? : #{is_teacher} "
	  is_teacher
  end

  def superuser?
	  is_superuser = ['administrator','moderator'].include? self.ranga
	  logger.debug "Czy użytkownik #{self.nazwa_uz} jest superużytkownikiem ? : #{is_superuser} "
    is_superuser
	end
end
