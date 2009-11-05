class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string  :address_type, :default => 'shipping'
      t.string  :address1
      t.string  :address2
      t.integer :city_id
      t.integer :cart_id
      t.string  :zip
      t.timestamps
    end
  end
  
  def self.down
    drop_table :addresses
  end
end
