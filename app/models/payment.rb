class Payment < ActiveRecord::Base
  METHODS = [["Manual", "manual"],["Deposit","deposit"],["Credit Card","credit_card"]]
  
  belongs_to      :order
  attr_accessible :order_id, :amount, :payment_method
  
end
