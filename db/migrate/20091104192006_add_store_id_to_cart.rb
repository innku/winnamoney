class AddStoreIdToCart < ActiveRecord::Migration
  def self.up
    change_table :carts do |t|
      t.integer :store_id
    end
  end

  def self.down
    change_table :carts do |t|
      t.remove  :store_id
    end
  end
end
