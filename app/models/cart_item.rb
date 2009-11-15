class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  
  attr_accessor :tax_included
  
  def name
    self.product.name
  end
  
  def price
    price = self.quantity * (self.cart.owner_purchase? ? self.product.price_for_owner : self.product.selling_price)
    price *= (1.0 + product.tax/100) if taxes_apply?
    price
  end
  
  def unit_price
    (self.cart.owner_purchase? ? self.product.price_for_owner : self.product.selling_price)
  end
  
  def increase!
    self.quantity +=1
    self.save!
  end
  
  def taxes_apply?
    unless cart.addresses.empty?
      return (product.state == cart.shipping_state) && product.tax != 0
    end
  end
  
  def decrease!
    if self.quantity > 1
      self.quantity -=1
      self.save!
    elsif self.quantity == 1
      self.quantity -=1
      self.destroy
    end
  end
  
end