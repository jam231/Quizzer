class Quiz < ActiveRecord::Base
    self.table_name = 'quiz'
    self.primary_key = :id_quizu
    has_many :pytania, :foreign_key => 'id_quizu', :class_name => "Pytanie"
    belongs_to :grupa_quizowa, :class_name => "GrupaQuizowa"
    belongs_to :uzytkownik, :class_name => "Uzytkownik"

  attr_accessible :pytania, :grupa_quizowa, :id_wlasciciela

  def usun_odpowiedzi_uzytkownikow!
		# ActiveRecord nie chce tego normalnie usuwac, bo niby nie ma primary key...

	  query = ActiveRecord::Base.send :sanitize_sql_array, ["select * from usun_odpowiedzi_uzytkownikow(%s)", self.id_quizu]
	  query_results = self.connection.execute(query)
  end

	def podejscia_uzytkownika(uzytkownik)
		id_uz = if uzytkownik.is_a? Integer then uzytkowniky else uzytkownik.id_uz end
		query = ActiveRecord::Base.send :sanitize_sql_array, ["select * from podejscia_uzytkownika(%s, %s)", id_uz, self.id_quizu]
		query_results = self.connection.execute(query)
		query_results.map do |dict|
			{:zdobyte_pkt => dict["zdobyte_pkt"].to_i, :max_pkt => dict["max_pkt"].to_i,
			 :data_wyslania => Time.zone.parse(dict["data_wyslania"]) }
		end
  end

  def active?
		# stub
		true
	end

  def pytania_widoczne
    pytania.select{|p| p.ukryte == false}
  end

end
