class ChangeUserAddressAttributes < ActiveRecord::Migration
  def self.up
    rename_column :users, :address_1, :address1
    rename_column :users, :address_2, :address2
    add_column    :users, :zip, :string
  end

  def self.down
    rename_column :users, :address1, :address_1
    rename_column :users, :address2, :address_2
    remove_column :users, :zip
  end
end
