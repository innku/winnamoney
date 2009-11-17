class AddHomeAttributeToProduct < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.boolean :on_home, :default => false
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :on_home
    end
  end
end
