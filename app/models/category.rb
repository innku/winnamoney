class Category < ActiveRecord::Base
  validates_presence_of :name, :message => 'La categor&iacute;a debe tener un nombre'
  has_many              :subcategories
end