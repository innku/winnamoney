class AddOrderTypeToOrders < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.string :order_type, :default => "product_purchase"
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :order_type
    end
  end
end
