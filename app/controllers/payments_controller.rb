class PaymentsController < ApplicationController
  
  def new
    @order = Order.find(params[:order_id])
    @payment = @order.payments.build(:amount => 189)
  end
  
  def create
    @order = Order.find(params[:order_id])
    @payment = @order.payments.build(params[:payment])
    if @payment.save
      @order.complete!
      flash[:notice] = "Successfully created payment."
      redirect_to users_path
    else
      render :action => 'new'
    end
  end
end
