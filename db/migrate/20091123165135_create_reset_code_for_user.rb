class CreateResetCodeForUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :reset_code, :limit => 40
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :reset_code
    end
  end
end
