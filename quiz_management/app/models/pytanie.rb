class Pytanie < ActiveRecord::Base
    self.table_name = 'pytanie'
    self.primary_key = :id_pyt

    has_many :odpowiedzi, :foreign_key => 'id_pyt', :class_name => "OdpowiedzWzorcowa"
    belongs_to :quiz, :class_name => "Quiz"
    belongs_to :kategoria, :class_name => "Kategoria"

    #def odpowiedzi
    #  self.connection.execute(sanitize_sql(["SELECT * FROM odpowiedzi(?)", id_quizu]))
    #end
end
