class AddExpressTokenToOrders < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.string :express_token
      t.string :express_payer_id
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :express_token
      t.remove :express_payer_id
    end
  end
end
