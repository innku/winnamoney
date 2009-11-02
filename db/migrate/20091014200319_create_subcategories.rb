class CreateSubcategories < ActiveRecord::Migration
  def self.up
    create_table :subcategories do |t|
      t.string  :name
      t.integer :category_id
    end
  end

  def self.down
    drop_table  :subcategories
  end
end
