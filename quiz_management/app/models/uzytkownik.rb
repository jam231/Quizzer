class Uzytkownik < ActiveRecord::Base
    self.table_name = 'uzytkownik'
    self.primary_key = :id_uz

end
