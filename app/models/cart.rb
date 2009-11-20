class Cart < ActiveRecord::Base
  
  belongs_to  :store
  has_many    :items,    :class_name => 'CartItem'
  has_many    :products, :through => :cart_items
  has_many    :addresses
  has_many    :orders
    
  def empty?
    self.items.empty?
  end
  
  def owner_purchase?
    self.owner_purchase
  end
  
  def owner_purchase!
    self.owner_purchase =true
    self.save
  end
  
  def price
    @price=0
    self.items.each do |item|
      @price += item.price
    end
    @price
  end
  
  def shipping_price
    @shipping=0
    self.items.each do |item|
      @shipping += item.product.local_transport
    end
    @shipping
  end
  
  def handling
    @handling=0
    self.items.each do |item|
      @handling += item.product.handling
    end
    @handling
  end
  
  def total
    @price + @shipping + @handling
  end
  
  def complete!
    self.status = "complete"
    self.purchased_at = Time.now
    self.save
  end
  
  def shipping_state
    shipping.city.state
  end
  
  def billing
    self.addresses.find_by_address_type("billing")
  end
  
  def shipping
    self.addresses.find_by_address_type("shipping")
  end
  
  def has_addresses?
    unless self.addresses.empty?
      return true if addresses.first.valid? and addresses.second.valid?
    end
    return false
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