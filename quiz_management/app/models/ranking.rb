class Ranking < ActiveRecord::Base
  self.primary_keys = :id_uz, :id_grupy

  #Byc moze to zle modelowanie.

  has_one :uzytkownik, :foreign_key => 'id_uz', :class_name => "Uzytkownik"
  belongs_to :grupa, :foreign_key => 'id_grupy', :class_name => "GrupaQuizowa"
  self.table_name = 'ranking'

<<<<<<< HEAD
	def self.przelicz_ranking!
		ActiveRecord::Base.connection.execute("SELECT * FROM przelicz_ranking()")
=======
  def self.przelicz_ranking!(grupa = nil)
	  if grupa.nil?
		  ActiveRecord::Base.connection.execute("SELECT * FROM przelicz_ranking()")
	  else
			id_grupy = if grupa.is_a? Integer then grupa else grupa.id_grupy end
	    query = ActiveRecord::Base.send :sanitize_sql_array, ["select * from przelicz_grupe(%s)", id_grupy]
	    query_results = self.connection.execute(query)
		end
>>>>>>> origin/master
	end
end
