class Typ < ActiveRecord::Base
    self.table_name = 'typ'
    self.primary_key = :id_typu
    has_many :pytania, :foreign_key => 'id_typu', :class_name => "Pytanie"
    def self.default
      self.first
    end
end
