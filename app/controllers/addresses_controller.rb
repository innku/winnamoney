class AddressesController < ApplicationController
  
  before_filter :find_store, :find_cart, :already_has_address
  
  def create
    @shipping_address = @cart.addresses.build(params[:shipping_address])
    @billing_address = @cart.addresses.build(params[:billing_address]) unless @shipping_address.same_for_billing?
    if @shipping_address.valid? and (not @billing_address or @billing_address.valid? )
      @shipping_address.save
      @billing_address.save if @billing_address
      flash[:notice] = "Successfully saved addresses."
      redirect_to new_order_path
    else
      flash[:error] = "Please enter a correct address"
      redirect_to @cart
    end
  end
  
  protected
  
  def already_has_address
    unless @cart.addresses.empty?
      redirect_to @cart
      return false
    end
  end
  
end
