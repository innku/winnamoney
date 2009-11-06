class CartsController < ApplicationController
  
  before_filter :find_store, :find_cart, :needs_to_have_items
  
  def show
    @shipping_address = Address.new(:same_for_billing => true)
    @billing_address = Address.new(:address_type => 'billing')
  end
  
  private
  
  def needs_to_have_items
    if @cart.empty?
      redirect_to current_store
      return false
    end
  end
  
end