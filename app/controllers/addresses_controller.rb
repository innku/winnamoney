class AddressesController < ApplicationController
  
  before_filter :find_store, :find_cart, :cant_create_more_addresses
  
  def new
    @shipping_address = Address.new(:same_for_billing => true)
    @billing_address = Address.new(:address_type => 'billing')
  end
  
  def create
    @shipping_address = @cart.addresses.build(params[:shipping_address])
    @billing_address = @cart.addresses.build(params[:billing_address]) unless @shipping_address.same_for_billing?
    if @shipping_address.valid? and (not @billing_address or @billing_address.valid? )
      @shipping_address.save
      @billing_address.save if @billing_address
      flash[:notice] = "Successfully saved addresses."
      redirect_to current_store
    else
      @billing_address ||= @cart.addresses.build(:address_type => 'billing')
      render :action => 'new'
    end
  end
  
  protected
  
  def cant_create_more_addresses
    unless @cart.addresses.empty?
      redirect_to current_store
      return false
    end
  end
  
end
