class AddCartIdToOrder < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.integer :cart_id
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :cart_id
    end
  end
end
