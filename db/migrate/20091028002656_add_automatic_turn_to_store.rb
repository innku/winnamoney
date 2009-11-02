class AddAutomaticTurnToStore < ActiveRecord::Migration
  def self.up
    change_table  :stores do |t|
      t.string :auto_turn, :default => 'left'
    end
  end

  def self.down
    change_table  :stores do |t|
      t.remove :auto_turn
    end
  end
end
