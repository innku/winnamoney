class OrdersController < ApplicationController
  before_filter :find_store, :only => [:new, :create, :express]
  before_filter :find_cart, :only => [:new, :create, :express]
  after_filter  :clear_register_session, :only => [:create]
  after_filter  :clear_shopping_session, :only => [:create]
  
  def new
    if not in_register_process?
      build_cart_order_types(:current_order => nil, :is_suscription => false)
      render 'confirm_order'
    else
      @user = User.find(session[:registered_user_id])
      build_all_order_types(:current_order => nil)
      render
    end
  end
  
  def create
    if not in_register_process?
      @order = @cart.orders.build(params[:order])
      @order.user = @current_user
    else
      @user = User.find(session[:registered_user_id])
      @order = @user.orders.build(params[:order])
    end
    @order.ip_address = request.remote_ip
    if @order.save
      case @order.payment_method
        when "credit_card"
          if @order.purchase!
            @order.complete!
            render 'success_credit_card'
          else
            @order.decline!
            render 'failure_credit_card'
          end
      end
    else
      build_all_order_types(@order)
      render 'new'
    end
  end
  
  def express
    if not in_register_process?
      @order = @cart.orders.build
    else
      @order = @user.orders.build
    end
    response = EXPRESS_GATEWAY.setup_purchase(@order.price_in_cents, 
    :ip => request.remote_ip,
    :return_url => new_order_url(),
    :cancel_return_url => new_order_url())
    
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  private
  
  def build_cart_order_types(options)
      @credit_card_order = (not options[:current_order].nil? and options[:current_order].credit_card?) ? options[:current_order] : Order.new()
      @express_checkout_order = Order.new(:express_token => params[:token])
      if options[:is_suscription]
        @credit_card_order.order_type = 'suscription'
        @express_checkout_order.order_type = 'suscription'
      end
  end
  
  def build_all_order_types(options)
    build_cart_order_types(:current_order => options[:current_order], :is_suscription => true)
    @deposit_order = (not options[:current_order].nil? and options[:current_order].deposit?) ? options[:current_order] : Order.new(:payment_method => 'deposit', :order_type => 'suscription')
    @contact_later_order = (not options[:current_order].nil? and options[:current_order].contact_later?) ? options[:current_order] : Order.new(:payment_method => 'contact_later', :order_type => 'suscription')
  end
  
end