class Pytanie < ActiveRecord::Base
    self.table_name = 'pytanie'
    self.primary_key = :id_pyt

    has_many :odpowiedzi, :foreign_key => 'id_pyt', :class_name => "OdpowiedzWzorcowa"
    belongs_to :typ, :foreign_key => 'id_typu', :class_name => "Typ"
    belongs_to :quiz, :foreign_key => 'id_quizu', :class_name => "Quiz"
    belongs_to :kategoria, :foreign_key => 'id_kategorii', :class_name => "Kategoria"

    attr_accessible :id_quizu, :tresc, :id_kategorii, :pkt, :id_typu, :id_autora, :id_pyt

    accepts_nested_attributes_for :odpowiedzi

  def r_odpowiedzi
    result = []
    result += odpowiedzi.shuffle[0..(typ.liczba_odp-1)]
    if result.index{ |odpowiedz| odpowiedz.poziom_poprawnosci==100 }.nil?
      id_poprawnej_odpowiedzi = odpowiedzi.index { |odpowiedz| odpowiedz.poziom_poprawnosci == 100 }

      if (id_poprawnej_odpowiedzi.nil?)
        raise "Brak poprawnej odpowiedzi dla pytania #{id_pyt.to_i}."
      else
        result[0] = odpowiedzi[id_poprawnej_odpowiedzi]
      end
    end

    result
  end

  def otwarte?
    typ.liczba_odp==1
  end

  def wielokrotnego_wyboru?
    typ.wielokrotnego_wyboru
  end
end
