class AddTreeStructureToUser < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.integer :parent_id
      t.integer :left_id
      t.integer :right_id
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove :parent_id
      t.remove :left_id
      t.remove :right_id
    end
  end
end
