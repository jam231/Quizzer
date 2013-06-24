class DostepGrupa < ActiveRecord::Base
    self.table_name = 'dostep_grupa'

    attr_accessible :id_uz, :id_grupy, :prawa_dost
end
