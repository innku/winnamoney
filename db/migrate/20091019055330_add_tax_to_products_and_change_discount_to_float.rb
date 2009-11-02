class AddTaxToProductsAndChangeDiscountToFloat < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.float   :tax
      t.change  :discount, :float
    end
  end

  def self.down
    change_table :products do |t|
      t.remove  :tax
      t.change  :discount, :integer
    end
  end
end
