class AddStatusToStore < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.string :status, :default => 'incomplete'
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove :status
    end
  end
end
