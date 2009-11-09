class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :order_id
      t.float   :amount
      t.string  :payment_method
      t.timestamps
    end
  end
  
  def self.down
    drop_table :payments
  end
end
