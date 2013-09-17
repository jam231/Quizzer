# encoding: UTF-8

class Pytanie < ActiveRecord::Base
    self.table_name = 'pytanie'
    self.primary_key = :id_pyt

    has_many :odpowiedzi, :foreign_key => 'id_pyt', :class_name => "OdpowiedzWzorcowa"
    has_many :odpowiedzi_uzytkownika, :foreign_key => 'id_pyt', :class_name => "OdpowiedzUzytkownika"
    belongs_to :typ, :foreign_key => 'id_typu', :class_name => "Typ"
    belongs_to :quiz, :foreign_key => 'id_quizu', :class_name => "Quiz"
    belongs_to :kategoria, :foreign_key => 'id_kategorii', :class_name => "Kategoria"

    attr_accessible :id_quizu, :tresc, :id_kategorii, :pkt, :id_typu, :id_autora, :id_pyt,
                    :odpowiedzi, :odpowiedzi_attributes

    accepts_nested_attributes_for :odpowiedzi,  allow_destroy: true
    accepts_nested_attributes_for :odpowiedzi_uzytkownika

    validates_presence_of :tresc, :message => "Musisz określić treść pytania"
    validates_presence_of :pkt, :message => "Musisz określić punkty za pytanie"
    validates_numericality_of :pkt, :greater_than_or_equal_to => 0.0, :message => "Pytanie nie może dawać ujemnych punktów"



  def r_odpowiedzi
    result = []
    result += odpowiedzi.shuffle[0..(typ.liczba_odp-1)]
    if result.index{ |odpowiedz| odpowiedz.poziom_poprawnosci==100 }.nil?
      id_poprawnej_odpowiedzi = odpowiedzi.index { |odpowiedz| odpowiedz.poziom_poprawnosci == 100 }

      if id_poprawnej_odpowiedzi.nil?
        raise "Brak poprawnej odpowiedzi dla pytania #{id_pyt.to_i}."
      else
        result[0] = odpowiedzi[id_poprawnej_odpowiedzi]
      end
    end

    result
  end

  def punkty_za_odpowiedz(user, time)
		query = ActiveRecord::Base.send :sanitize_sql_array, ["select * from pkt_za_pytanie(%s,%s,'%s')", user.id_uz, self.id_pyt, time]
		query_results = self.connection.execute(query)
		punkty_za_odpowiedz = query_results[0]["pkt_za_pytanie"]
	end

  def otwarte?
    typ.liczba_odp==1
  end

  def wielokrotnego_wyboru?
    typ.wielokrotnego_wyboru
  end

  def ma_prawidlowa_odpowiedz?
    #Pytanie ma prawidlowa odpowiedz jesli nie jest wielokrotnego wyboru (takie moze nie miec) oraz
    # ma przynajmniej 1 odpowiedz z poziomem poprawnosci 100
    (wielokrotnego_wyboru?) || (odpowiedzi.select{|odp| odp.poziom_poprawnosci == 100 }.count > 0)
  end

  def poprawne?
    (odpowiedzi.count >= typ.liczba_odp) && (ma_prawidlowa_odpowiedz?)
  end
end
