  class GrupaQuizowa < ActiveRecord::Base
    self.table_name = 'grupa_quizowa'
    self.primary_key = :id_grupy

    has_many :dostep_grupa, :foreign_key => 'id_grupy', :class_name => "DostepGrupa"

  end

