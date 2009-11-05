class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  
  def name
    self.product.name
  end
  
  def price
    self.quantity * self.product.selling_price
  end
  
  def increase!
    self.quantity +=1
    self.save!
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