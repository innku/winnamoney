class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string  :account_type
      t.string  :cell
      t.string  :account_number
      t.string  :routing
      t.string  :ssn
    end
  end

  def self.down
    change_table :users do |t|
      t.remove  :account_type
      t.remove  :cell
      t.remove  :account_number
      t.remove  :routing
      t.remove  :ssn
    end
  end
end
