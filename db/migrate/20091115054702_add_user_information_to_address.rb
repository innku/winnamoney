class AddUserInformationToAddress < ActiveRecord::Migration
  def self.up
    change_table :addresses do |t|
      t.string :names
      t.string :last_names
      t.string :email
      t.string :phone
    end
  end

  def self.down
    change_table :addresses do |t|
      t.remove :names
      t.remove :last_names
      t.remove :email
      t.remove :phone
    end
  end
end
