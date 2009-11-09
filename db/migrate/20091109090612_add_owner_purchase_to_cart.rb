class AddOwnerPurchaseToCart < ActiveRecord::Migration
  def self.up
    change_table :carts do |t|
      t.boolean :owner_purchase
    end
  end

  def self.down
    change_table :carts do |t|
      t.remove :owner_purchase
    end
  end
end
