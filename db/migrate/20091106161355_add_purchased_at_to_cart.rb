class AddPurchasedAtToCart < ActiveRecord::Migration
  def self.up
    change_table :carts do |t|
      t.datetime      :purchased_at, :default => nil
    end
  end

  def self.down
    change_table :carts do |t|
      t.remove   :purchased_at
    end
  end
end
