class Cart < ActiveRecord::Base
  
  belongs_to  :store
  has_many    :items,    :class_name => 'CartItem'
  has_many    :products, :through => :cart_items
  has_many    :addresses
  has_many    :orders
  
  def empty?
    self.items.empty?
  end
  
  def price
    total=0
    self.items.each do |item|
      total += item.price
    end
    total
  end
  
  def taxes
    taxes=0
    shipping_state = self.addresses.find_by_address_type("shipping").city.state
    self.items.each do |item|
      taxes+= item.product.tax if shipping_state == item.product.state
    end
    taxes
  end
  
  def total
    price + taxes
  end
  
  def complete!
    self.status = "complete"
    self.purchased_at = Time.now
    self.save
  end
  
  def add_product!(product)
    item = self.items.find_by_product_id(product.id)
    unless item.nil?
      item.quantity += 1
    else
      item = self.items.build(:product_id => product.id)
    end
    item.save
  end
  
end