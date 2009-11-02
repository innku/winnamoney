class Tag < ActiveRecord::Base
  belongs_to  :subcategory
  has_many    :products
  
  def self.siblings(subcategory_id)
    unless subcategory_id.nil?
      self.find_all_by_subcategory_id(subcategory_id)
    else
      return []
    end
  end
  
end