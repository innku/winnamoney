class Address < ActiveRecord::Base
  belongs_to      :cart
  belongs_to      :city
  attr_accessible :address_type, :address1, :address2, :city_name,:city_id, :zip, :same_for_billing, :names, :last_names, :email, :phone
  
  validates_presence_of   :names
  validates_presence_of   :last_names
  validates_presence_of   :email
  validates_presence_of   :phone
  validates_presence_of   :address_type, :message => "The address should be for billing or shipping"
  validates_presence_of   :address1,:message =>  "Please enter your address"
  validates_presence_of   :city_id,:message =>  "Please enter your city"
  validates_presence_of   :zip, :message => "Please enter your zip code"
  validates_numericality_of :zip, :message => "Please enter a valid zip code"
  
  
  attr_accessor   :same_for_billing
  
  after_create      :check_billing_address!
  after_validation  :validate_cities
  
  def city_name
    if city
      return "#{self.city.name}, #{self.city.state.name}"
    end
  end
  
  def city_name=(city_name)
    write_attribute(:city_name, city_name)
    @cities = City.find_by_full_name(city_name)
    if @cities.size == 1
      self.city = @cities.first
    else
      self.city = nil
    end
  end
  
  def same_for_billing?
    if self.same_for_billing == true or self.same_for_billing.to_i == 1
      return true
    else
      return false
    end
  end
  
  def shipping?
    self.address_type == "shipping"
  end
  
  protected
  
  def validate_cities
     if !self.city and @cities
        if @cities.size > 1
          errors.add(:city_id, "We found many cities with your request, please be more specific using the <em>City, State</em> format")
        else @cities.size == 0
          errors.add(:city_id, "We haven't found any city with your request")
        end
      end
  end
  
  def check_billing_address!
    if self.shipping? and self.same_for_billing?
      logger.warn "COPY MADE #{self.same_for_billing?}"
      billing = Address.new(self.attributes)
      billing.address_type = "billing"
      billing.cart_id = self.cart_id
      billing.save
    end
  end
  
end
