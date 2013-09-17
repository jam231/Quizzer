class DostepGrupa < ActiveRecord::Base
    self.table_name = 'dostep_grupa'

    belongs_to :uzytkownik, :foreign_key => :id_uz, :class_name => "Uzytkownik"
    belongs_to :grupa, :foreign_key => :id_grupy, :class_name => "GrupaQuizowa"

    attr_accessible :id_uz, :id_grupy, :prawa_dost
end
