class Quiz < ActiveRecord::Base
    self.table_name = 'quiz'
    self.primary_key = :id_quizu
    has_many :pytania, :foreign_key => 'id_quizu', :class_name => "Pytanie"
    belongs_to :grupa_quizowa, :class_name => "GrupaQuizowa"
    belongs_to :uzytkownik, :class_name => "Uzytkownik"

  attr_accessible :pytania
end
