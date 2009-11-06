class AddCreditCardAttributesToPaymentInformation < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.string :payment_method, :default => 'credit_card'
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :payment_method
      t.remove :ip_address
      t.remove :first_name
      t.remove :last_name
      t.remove :card_type
      t.remove :card_expires_on
    end
  end
end
