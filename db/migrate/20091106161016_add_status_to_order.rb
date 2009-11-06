class AddStatusToOrder < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.string :status, :default => 'incomplete'
    end 
  end

  def self.down
    change_table :orders do |t|
      t.remove :status
    end
  end
end
