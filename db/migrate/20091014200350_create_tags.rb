class CreateTags < ActiveRecord::Migration
  def self.up
    create_table  :tags do |t|
      t.string  :name
      t.integer :subcategory_id
    end
    
    change_table  :products do |t|
      t.integer :tag_id
    end
    
  end

  def self.down
    drop_table  :tags
    
    change_table  :products do |t|
      t.remove :tag_id
    end
    
  end
end
