class CreatePaymentInformation < ActiveRecord::Migration
  def self.up
    create_table :payment_information do |t|
      t.integer :user_id
      t.string  :account_type
      t.string  :account_number
      t.string  :routing
      t.string  :ssn
      t.string  :rfc
    end
  end

  def self.down
    drop_table  :payment_information
  end
end
