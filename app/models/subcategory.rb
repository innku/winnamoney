class Subcategory < ActiveRecord::Base
  belongs_to  :category
  has_many    :tags
  
  def self.siblings(category_id)
    unless category_id.nil?
      self.find_all_by_category_id(category_id)
    else
      return []
    end
  end
  
end