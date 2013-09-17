class Kategoria < ActiveRecord::Base
	self.table_name = 'kategoria'
  self.primary_key = :id_kategorii

  def self.default
    self.first
  end
end
