class CartItemsController < ApplicationController
  HELPER = Object.new.extend(ActionView::Helpers::NumberHelper)
  
  before_filter :find_store, :find_cart
  
  def create
    product = Product.find(params[:product_id])
    respond_to do |format|
      if @cart.add_product!(product)
        format.js { render :partial => '/products/cart' }
        format.html { redirect_to product }
      end
    end
  end
  
  def update
    @item = CartItem.find(params[:id])
    logger.warn "PARAMS: " + params[:update_action]
      if params[:update_action] == "increase"
        @item.increase!
      elsif params[:update_action] == "decrease"
        @item.decrease!
      end
      respond_to do |format|
        format.js { 
          render :json => {:id => @item.id, :new_quantity => @item.quantity, :new_total => number_to_currency(@item.cart.price), :redirect_cart => @item.cart.empty? }.to_json 
        }
      end
    end
  
  def destroy
    @item = CartItem.find(params[:id])
    @item.destroy
    respond_to do |format|
      format.js { render :json => {:id => @item.id, :new_total => number_to_currency(@item.cart.price), :redirect_cart => @item.cart.empty? }.to_json }
    end
  end
    
  private
  
  def number_to_currency(price)
    HELPER.number_to_currency(price)
  end
  
end