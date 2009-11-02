class AddContactOptionToPaymentInformation < ActiveRecord::Migration
  def self.up
    change_table :payment_information do |t|
      t.boolean :contact_me
    end
  end

  def self.down
    change_table :payment_information do |t|
      t.remove :contact_me
    end
  end
end
